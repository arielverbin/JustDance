import cv2
from Inference.vit_inference import VitInference

# Initialize the webcam (camera index 0)
capture = cv2.VideoCapture(0)

# set is_video=True to enable tracking in video inference
# be sure to use VitInference.reset() function to reset the tracker after each video
# There are a few flags that allows to customize VitInference, be sure to check the class definition
model_path = './Inference/weights/vitpose-b-coco.pth'
yolo_path = './Inference/weights/yolov5su.pt'


# If you want to use MPS (on new MacBooks) use the torch checkpoints for both ViTPose and Yolo
# If device is None will try to use cuda -> mps -> cpu (otherwise specify 'cpu', 'mps' or 'cuda')
# dataset and det_class parameters can be inferred from the ckpt name, but you can specify them.
model = VitInference(model_path, yolo_path)

counter = 0
# Image to run inference RGB format
while True:
    ret, img = capture.read()
    if not ret:
        print("Error: Could not read frame from camera.")
        break

    # img = cv2.flip(img, 1)  # flip horizontally
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # Infer keypoints, output is a dict where keys are person ids and values are keypoints
    # (np.ndarray (25, 3): (y, x, score)) If is_video=True the IDs will be consistent among the ordered video frames.
    keypoints = model.inference(img)
    print(counter)
    counter = counter + 1
    # call model.reset() after each video

    img = model.draw(show_yolo=True)  # Returns RGB image with drawings
    cv2.imshow('image', cv2.cvtColor(img, cv2.COLOR_RGB2BGR))

    # Press 'q' to exit the loop
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break
