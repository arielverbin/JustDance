import cv2
from Comparasion.pose import Pose


class GameInitializer:
    """
    Detects the players in the frame, waits for them to raise their hands, then start.
    """

    def __init__(self, game_manager, numer_players):
        self.number_players = numer_players
        self.game_manager = game_manager

    def init_game(self, comparator, starting_pose, threshold):
        capture = self.game_manager.get_camera_access()
        model = self.game_manager.get_inference_model()

        while True:
            ret, img = capture.read()

            if not ret:
                print("Error: Could not read frame from camera.")
                break

            img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

            # Inference keypoints of every person in the frame.
            keypoints = model.inference(img=img)
            print(keypoints)

            players = []

            if keypoints:
                for player_id, current_pose in keypoints.items():
                    # Calculate comparison value.
                    comparison, _ = comparator.compare(processed_target=starting_pose, pose=Pose(current_pose))
                    if comparison < threshold:
                        players.append(player_id)

            if len(players) >= self.number_players:
                return players[0:self.number_players]
