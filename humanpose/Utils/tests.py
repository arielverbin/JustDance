import cv2
import numpy as np
from Inference.vit_inference import VitInference
from Utils.game_manager import GameManager
from Comparasion.angular_score import AngularScore
from Utils.game_initializer import GameInitializer


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


model_path = '../Inference/weights/vitpose-b-coco.pth'
yolo_path = '../Inference/weights/yolov5su.pt'
model = VitInference(model_path, yolo_path)
game_manager = GameManager(inference_model=model)
comparator = AngularScore(factor=5)

game_init = GameInitializer(game_manager, numer_players=2)
print(game_init.init_game(comparator, starting_pose=None, threshold=15))

# draw_keypoints({1: [[     237.73,      614.31,      0.9383],
#        [     221.64,       628.3,     0.97267],
#        [      222.8,       597.8,      0.9637],
#        [     229.77,       651.9,     0.98263],
#        [     233.48,      571.32,     0.96457],
#        [     331.28,      697.38,     0.90198],
#        [     327.52,      527.29,     0.86298],
#        [      349.8,      821.66,     0.91605],
#        [     351.32,      396.48,     0.93134],
#        [     243.93,      818.38,     0.92239],
#        [     238.85,      405.32,     0.92957],
#        [      584.1,      653.63,     0.72214],
#        [     579.19,      544.23,     0.70247],
#        [     719.85,       658.9,      0.6968],
#        [     718.88,      518.82,     0.64353],
#        [     706.81,      653.92,     0.16169],
#        [     698.87,       530.9,     0.12463]]})
