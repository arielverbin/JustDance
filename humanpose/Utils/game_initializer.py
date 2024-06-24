import cv2
from Comparasion.pose import Pose
from Comparasion.angular_score import AngularScore


class GameInitializer:
    """
    Detects the players in the frame, waits for them to raise their hands, then start.
    """

    RAISING_HANDS_POSE = [92.49049328780853, 93.01381417016235,
                         173.0319190082875, 171.8644955749707,
                         94.47758770390396, 95.12169025486698,
                         149.44242527213777, 150.96153908668865,
                         86.76105656504188, 83.63966547618718,
                         76.03793685383174, 78.48740126778407,
                         155.50008981717187, 158.84009273968073]

    def __init__(self, game_manager, numer_players):
        self.number_players = numer_players
        self.game_manager = game_manager

    def init_game(self, starting_pose, threshold):
        comparator = AngularScore(factor=5)
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

            players = []

            if keypoints:
                for player_id, current_pose in keypoints.items():
                    # Calculate comparison value.
                    comparison = comparator.compare(preprocessed_target=starting_pose, pose=Pose(current_pose))
                    if comparison < threshold:
                        players.append(player_id)

            if len(players) >= self.number_players:
                return players[0:self.number_players]
