import cv2
from Comparasion.pose import Pose
from Comparasion.utils import calc_angle
import threading


class GameInitializer:
    """
    Detects the players in the frame, waits for them to raise their hands, then start.
    """

    RAISING_HANDS_POSE = 1

    def __init__(self, game_manager, numer_players):
        self.lock = threading.Lock()
        self.condition = threading.Condition(self.lock)
        self.number_players = numer_players
        self.should_cancel = False
        self.should_start = False
        self.game_manager = game_manager

        self.players = None

        self.players_status = None

    @staticmethod
    def _get_angle_checker(bigger_than, critical_angle):
        """
        Returns a checker (function) for an angle.
        Args:
            bigger_than: bool, check if a given angle is bigger than something, or smaller than.
            critical_angle: float, the angle to be compared to.
        """
        return lambda angle: angle >= critical_angle if bigger_than else angle <= critical_angle

    def init_game(self, starting_pose):
        """
        Loops until there are enough players who are making the starting pose.
        Args:
            starting_pose: the target pose that triggers the game start.
        Returns:

        """
        capture = self.game_manager.get_camera_access()
        model = self.game_manager.get_inference_model()

        confidence_count = 0
        confidence_t = 3

        while True:

            with self.lock:
                print("init cancel??")
                if self.should_cancel:
                    print("init canceling!!1")
                    return

            ret, img = capture.read()

            if not ret:
                print("Error: Could not read frame from camera.")
                break

            img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

            # Inference keypoints of every person in the frame.
            keypoints = model.inference(img=img)

            players = []

            if keypoints:
                for player_id, current_pose in keypoints.items():
                    # Check if player is raising their hands.
                    if self._is_posing(starting_pose, current_pose):
                        players.append(player_id)

            with self.lock:
                self.players_status = players
                self.condition.notify_all()

                if players != self.players:
                    self.players = players

                if len(players) == self.number_players:
                    confidence_count += 1
                    if confidence_count == confidence_t:
                        self.should_start = True
                        self.condition.notify_all()
                        return
                else:
                    confidence_count = 0

    def cancel_game(self):
        """
        Cancel game, notify the thread of game init.
        """
        with self.lock:
            self.should_cancel = True

        self.game_manager.cancel_game()

    def _is_posing(self, target, pose):
        """
        Check if the pose is doing the target pose.
        Args:
            target: an identifier of the target pose. Currently only supporting "Raising hands".
            pose: the player's pose.

        Returns: bool, whether the player's pose is doing the target pose or not.
        """
        if target == self.RAISING_HANDS_POSE:

            left_shoulder, right_shoulder = 5, 6
            left_elbow, right_elbow = 7, 8
            left_wrist, right_wrist = 9, 10

            return ((pose[left_shoulder][0] > pose[left_elbow][0] > pose[left_wrist][0])
                    and (pose[right_shoulder][0] > pose[right_elbow][0] > pose[right_wrist][0]))

        else:
            raise NotImplementedError

    def get_players_status(self):
        """
        Get the current player status of the game initialization.
        Blocks the thread until new update is available.
        If should_start is true, then all players were raising their hands and the game should start!
        """
        with self.condition:
            while (not self.should_start) and self.players_status is None:
                self.condition.wait()

            status = self.players_status
            self.players_status = None
            return status, self.should_start


# TEST:
# from Inference.vit_inference import VitInference
# from Utils.game_manager import GameManager
#
# model_path = '../Inference/weights/vitpose-b-coco.pth'
# yolo_path = '../Inference/weights/yolov5su.pt'
# model = VitInference(model_path, yolo_path)
# game_manager = GameManager(inference_model=model)
# game_manager.init_camera()
# GameInitializer(game_manager, 1).init_game(GameInitializer.RAISING_HANDS_POSE)
