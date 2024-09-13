import cv2
import numpy as np


def draw_keypoints(player_dict):
    # Create a black image
    img = np.zeros((1080, 1020, 3), dtype=np.uint8)

    # Define colors for different players
    colors = [
        (255, 0, 0),  # Blue
        (0, 255, 0),  # Green
        (0, 0, 255),  # Red
        (255, 255, 0),  # Cyan
        (255, 0, 255),  # Magenta
        (0, 255, 255)  # Yellow
    ]

    for i, (player_id, keypoints) in enumerate(player_dict.items()):
        color = colors[i % len(colors)]
        for (y, x, prob) in keypoints:
            if prob > 0.5:  # Draw only keypoints with probability > 0.5
                cv2.circle(img, (int(x), int(y)), 5, color, -1)
                cv2.putText(img, f'{player_id}', (int(x), int(y) - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 1,
                            cv2.LINE_AA)

    # Display the image
    cv2.imshow('Keypoints', img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


# model_path = '../Inference/weights/vitpose-b-coco.pth'
# yolo_path = '../Inference/weights/yolov5su.pt'
# model = VitInference(model_path, yolo_path)
# game_manager = GameManager(inference_model=model)
#
# game_manager.init_camera()
#
# game_init = GameInitializer(game_manager, numer_players=1)
# print("#########################\n########  GAME  #########\n#########################\n",
#       game_init.init_game(starting_pose=GameInitializer.RAISING_HAND_POSE, threshold=30))
#
