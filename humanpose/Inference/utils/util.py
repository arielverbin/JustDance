from Inference.configs.ViTPose_coco import model_base
from typing import Any

import numpy as np


def dyn_model_import(dataset: str):
    return model_base


def pad_image(image: np.ndarray, aspect_ratio: float) -> tuple[np.ndarray, tuple[int | Any, int | Any]]:
    # Get the current aspect ratio of the image
    image_height, image_width = image.shape[:2]
    current_aspect_ratio = image_width / image_height

    left_pad = 0
    top_pad = 0
    # Determine whether to pad horizontally or vertically
    if current_aspect_ratio < aspect_ratio:
        # Pad horizontally
        target_width = int(aspect_ratio * image_height)
        pad_width = target_width - image_width
        left_pad = pad_width // 2
        right_pad = pad_width - left_pad

        padded_image = np.pad(image,
                              pad_width=((0, 0), (left_pad, right_pad), (0, 0)),
                              mode='constant')
    else:
        # Pad vertically
        target_height = int(image_width / aspect_ratio)
        pad_height = target_height - image_height
        top_pad = pad_height // 2
        bottom_pad = pad_height - top_pad

        padded_image = np.pad(image,
                              pad_width=((top_pad, bottom_pad), (0, 0), (0, 0)),
                              mode='constant')
    return padded_image, (left_pad, top_pad)
