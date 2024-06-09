import cv2
from Inference.vit_inference import VitInference
from Comparasion.compare_poses import Score

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

# Image to run inference RGB format
font = cv2.FONT_HERSHEY_SIMPLEX
font_scale = 1
color = (0, 0, 0)  # Green color
thickness = 2

feedbacks = {100: "Excellent", 90: "Great", 70: "Good", 50: "OK", 20: "Nah", 10: "X", 0: "X"}

correct_pose = [[92.806, 544.87, 0.95411],
                [83.074, 557.3, 0.96153],
                [77.407, 533.09, 0.97047],
                [91.793, 564.62, 0.90778],
                [79.274, 503.28, 0.98634],
                [156.92, 556.28, 0.95539],
                [159.7, 476.93, 0.90555],
                [163.7, 643.57, 0.93434],
                [260.33, 467.25, 0.92041],
                [153.08, 737.69, 0.92112],
                [256.48, 564.55, 0.91464],
                [324.92, 574.85, 0.78251],
                [340.27, 526.34, 0.79244],
                [316.31, 692.98, 0.97282],
                [499.24, 553.78, 0.95788],
                [456.67, 644.63, 0.92357],
                [651.52, 536.49, 0.93722]]

while True:
    ret, img = capture.read()
    if not ret:
        print("Error: Could not read frame from camera.")
        break

    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img = cv2.flip(img, 1)

    keypoints = model.inference(img)

    img = model.draw(show_yolo=True)  # Display predicted bbox and skeleton.

    # print(keypoints)  # For setting a new correct_pose.

    if keypoints:
        current_pose = next(iter(keypoints.values()))
        score = Score(current_pose, correct_pose, score_method="angular", factor=5).get_score()
    else:
        score = 0

    feedback = feedbacks[score]

    text = f"SCORE: {score}, {feedback}"
    text_size = cv2.getTextSize(text, font, font_scale, thickness)[0]
    img = img.copy()
    cv2.putText(img, text, (50, 50), font, font_scale, color, thickness, lineType=cv2.LINE_AA)

    # Show the image
    cv2.imshow('image', cv2.cvtColor(img, cv2.COLOR_RGB2BGR))

    # Press 'q' to exit the loop
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break
