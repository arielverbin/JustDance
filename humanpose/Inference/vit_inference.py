from typing import Optional
import typing
import threading

import cv2
import numpy as np
import torch

from ultralytics import YOLO

from Inference.configs.ViTPose_coco import data_cfg
from Inference.sort.sort import Sort
from Inference.model.model import ViTPose
from Inference.utils.util import pad_image
from Inference.model.postprocess import keypoints_from_heatmaps
from Inference.utils.util import dyn_model_import


try:  # Add bools -> error stack
    import pycuda.driver as cuda  # noqa: F401
    import pycuda.autoinit  # noqa: F401
except ModuleNotFoundError:
    pass

__all__ = ['VitInference']
np.bool = np.bool_

DETC_TO_YOLO_YOLOC = {
    'human': [0],
    'cat': [15],
    'dog': [16],
    'horse': [17],
    'sheep': [18],
    'cow': [19],
    'elephant': [20],
    'bear': [21],
    'zebra': [22],
    'giraffe': [23],
    'animals': [15, 16, 17, 18, 19, 20, 21, 22, 23]
}


class VitInference:
    """
    Class for performing inference using ViTPose models with YOLOv8 human detection and SORT tracking.

    Args:
        model_path (str): Path to the ViT model file (.pth, .onnx, .engine).
        yolo_path (str): Path of the YOLOv8 model to load.
        yolo_size (int, optional): Size of the input image for YOLOv8 model. Defaults to 320.

    """

    def __init__(self, model_path: str, yolo_path: str, yolo_size: Optional[int] = 320):

        self.lock = threading.Lock()
        self.condition = threading.Condition(self.lock)

        # Device priority is cuda / mps / cpu
        self.device = 'cpu'
        if torch.cuda.is_available():
            self.device = 'cuda'
        elif hasattr(torch.backends, 'mps') and torch.backends.mps.is_available():
            self.device = 'mps'

        self.yolo = YOLO(yolo_path, task='detect')
        self.yolo_size = yolo_size
        self.yolo_step = 1  # YOLO (and not tracker) will be used to predict every frame. TODO: check step > 1.
        self.tracker = None
        self.frame_counter = 0
        self.initialize_tracker()

        # Save state
        self._img = None
        self._tracker_res = None
        self._keypoints = None

        # Dataset can be set for visualization
        self.dataset = 'coco'

        # Set yolo to filter out non-human bboxes.
        self.yolo_classes = DETC_TO_YOLO_YOLOC['human']
        self.last_bboxes = None
        self.last_img = None

        # Dynamically import the model class
        model_cfg = dyn_model_import(self.dataset)

        self.target_size = data_cfg['image_size']

        self._vit_pose = ViTPose(model_cfg)
        self._vit_pose.eval()

        # Load weights from .pth file.
        ckpt = torch.load(model_path, map_location='cpu')
        if 'state_dict' in ckpt:
            self._vit_pose.load_state_dict(ckpt['state_dict'])
        else:
            self._vit_pose.load_state_dict(ckpt)

        self._vit_pose.to(torch.device(self.device))
        self._inference = self._inference_torch

    def reset(self):
        """
        Resets the model and prepare it for the next game.
        """
        self.tracker.reset()
        self.frame_counter = 0
        self._img = None
        self.last_bboxes = None
        self._tracker_res = None
        self.last_img = None
        self._keypoints = None

    def initialize_tracker(self):
        """
        Initialized the tracker.
        """
        min_hits = 3 if self.yolo_step == 1 else 1
        self.tracker = Sort(max_age=self.yolo_step,
                            min_hits=min_hits,
                            iou_threshold=0.3)

    def update_tracker(self, img: np.ndarray, protect):
        """
        Updates the person tracker with the next frame.
        Args:
            img: the next frame.
            protect: (list of ints) player ID's that should not be deleted, even if their detection is missing.

        Returns:
            the predicted bboxes for each person with a tracker.
        """
        # Use YOLOv8 for detection
        res_pd = np.empty((0, 5))
        if (self.tracker is None or
                (self.frame_counter % self.yolo_step == 0 or self.frame_counter < 3)):
            results = self.yolo(img, verbose=False, imgsz=self.yolo_size,
                                device=self.device if self.device != 'cuda' else 0,
                                classes=self.yolo_classes)[0]
            res_pd = np.array([r[:5].tolist() for r in
                               results.boxes.data.cpu().numpy() if r[4] > 0.35]).reshape((-1, 5))
        self.frame_counter += 1

        res_pd = self.tracker.update(res_pd, protect=protect)

        bboxes = res_pd[:, :4].round().astype(int)
        scores = res_pd[:, 4].tolist()
        ids = res_pd[:, 5].astype(int).tolist()

        # Prepare boxes for inference
        with self.lock:
            self.last_bboxes = res_pd[:, :4].round().astype(int), ids, scores
            self.last_img = img
            self.condition.notify_all()

        return bboxes, ids, scores

    def inference(self, img=None) -> dict[typing.Any, typing.Any]:
        """
        Inferences the keypoints for each person's pose in the image.
        Args:
            img: the image for performing the inference (if None, take image from tracker).

        Returns:
            dict: a 17-element array for each person with their predicted keypoints.
        """
        if img is not None:
            # Tracker is not used in a different thread, perform tracking here.
            self.update_tracker(img, protect=[])

        frame_keypoints = {}

        with self.lock:
            self.condition.wait_for(
                lambda: self.last_bboxes is not None and self.last_img is not None)

            bboxes, ids, scores = self.last_bboxes
            img = self.last_img

        if bboxes is None or img is None:
            # Tracker is yet to track anyone.
            return frame_keypoints

        pad_bbox = 10

        if ids is None:
            ids = range(len(bboxes))

        for bbox, id in zip(bboxes, ids):
            bbox[[0, 2]] = np.clip(bbox[[0, 2]] + [-pad_bbox, pad_bbox], 0, img.shape[1])
            bbox[[1, 3]] = np.clip(bbox[[1, 3]] + [-pad_bbox, pad_bbox], 0, img.shape[0])

            # Crop image and pad to 3/4 aspect ratio
            img_inf = img[bbox[1]:bbox[3], bbox[0]:bbox[2]]
            img_inf, (left_pad, top_pad) = pad_image(img_inf, 3 / 4)

            keypoints = self._inference(img_inf)[0]

            # Transform keypoints to original image
            keypoints[:, :2] += bbox[:2][::-1] - [top_pad, left_pad]
            frame_keypoints[id] = keypoints

        # Save state
        self._img = img
        self._tracker_res = bboxes, ids, scores
        self._keypoints = frame_keypoints

        return frame_keypoints

    def pre_img(self, img):
        """
        Preprocessing for the image before feeding to the model.
        Args:
            img: the image.

        Returns:
            The transformed and augmented image.
        """

        MEAN = [0.485, 0.456, 0.406]
        STD = [0.229, 0.224, 0.225]

        org_h, org_w = img.shape[:2]
        img_input = cv2.resize(img, self.target_size, interpolation=cv2.INTER_LINEAR) / 255
        img_input = ((img_input - MEAN) / STD).transpose(2, 0, 1)[None].astype(np.float32)
        return img_input, org_h, org_w

    @classmethod
    def postprocess(cls, heatmaps, org_w, org_h):
        """
        Convert predicted heatmaps to concrete keypoints.
        Args:
            heatmaps: the predicted heatmaps (for each keypoint)
            org_w: original width of the image.
            org_h: original height of the image.

        Returns:
            the concrete keypoints (each keypoint is [x,y,prob]).
        """
        points, prob = keypoints_from_heatmaps(heatmaps=heatmaps,
                                               center=np.array([[org_w // 2,
                                                                 org_h // 2]]),
                                               scale=np.array([[org_w, org_h]]),
                                               use_udp=True)
        return np.concatenate([points[:, :, ::-1], prob], axis=2)

    @torch.no_grad()
    def _inference_torch(self, img: np.ndarray) -> np.ndarray:
        """
        Inferences the keypoints for a single person.
        Args:
            img: the bbox (cropped from the original image)

        Returns:
            The predicted keypoints for that person.
        """
        # Prepare input data
        img_input, org_h, org_w = self.pre_img(img)
        img_input = torch.from_numpy(img_input).to(torch.device(self.device))

        # Feed to model
        heatmaps = self._vit_pose(img_input).detach().cpu().numpy()
        return self.postprocess(heatmaps, org_w, org_h)

    # def draw(self, show_yolo=True, confidence_threshold=0.5):
    #     """
    #     Draw keypoints and bounding boxes on the image.
    #
    #     Args:
    #         show_yolo (bool, optional): Whether to show YOLOv8 bounding boxes. Default is True.
    #         show_raw_yolo (bool, optional): Whether to show raw YOLOv8 bounding boxes. Default is False.
    #         confidence_threshold (float): only points with a confidence higher than this threshold will be drawn.
    #
    #     Returns:
    #         ndarray: Image with keypoints and bounding boxes drawn.
    #     """
    #     img = self._img.copy()
    #     bboxes, ids, scores = self._tracker_res
    #
    #     if show_yolo and self.tracker is not None:
    #         img = draw_bboxes(img, bboxes, ids, scores)
    #
    #     img = np.array(img)[..., ::-1]  # RGB to BGR for cv2 modules
    #     for idx, k in self._keypoints.items():
    #         img = draw_points_and_skeleton(img.copy(), k,
    #                                        joints_dict()[self.dataset]['skeleton'],
    #                                        person_index=idx,
    #                                        points_color_palette='gist_rainbow',
    #                                        skeleton_color_palette='jet',
    #                                        points_palette_samples=10,
    #                                        confidence_threshold=confidence_threshold)
    #     return img[..., ::-1]  # Return RGB as original
    #
    # @staticmethod
    # def draw_bboxes(img, bboxes, ids, scores):
    #     """
    #     Draw keypoints and bounding boxes on the image.
    #
    #     Args:
    #         show_yolo (bool, optional): Whether to show YOLOv8 bounding boxes. Default is True.
    #         show_raw_yolo (bool, optional): Whether to show raw YOLOv8 bounding boxes. Default is False.
    #         confidence_threshold (float): only points with a confidence higher than this threshold will be drawn.
    #
    #     Returns:
    #         ndarray: Image with keypoints and bounding boxes drawn.
    #     """
    #     img = img.copy()
    #     img = draw_bboxes(img, bboxes, ids, scores)
    #
    #     return img
