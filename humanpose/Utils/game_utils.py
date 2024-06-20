import cv2
import time
from Comparasion.pose import Pose


def track_players(model, game_manager):
    capture = cv2.VideoCapture(0)

    while True:
        ret, img = capture.read()

        game_manager.wait_for_game_start()

        if not ret:
            print("Error: Could not read frame from camera.")
            break
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img = cv2.flip(img, 1)

        model.update_tracker(img)

        if cv2.waitKey(1) & 0xFF == ord("q"):
            break

        if game_manager.should_terminate():
            break

    cv2.destroyAllWindows()


def score_dance(model, comparator, score_controller, game_manager):

    start_time = None

    while True:

        game_manager.wait_for_game_start()

        keypoints = model.inference()

        if start_time is None:
            start_time = time.time()

        current_time = time.time() - start_time

        scores = {}

        if keypoints:
            for player_id, current_pose in keypoints.items():
                # Calculate comparison value.
                comparison, _ = comparator.compare(pose=Pose(current_pose), time=current_time)
                # Convert comparison value to score.
                score = comparator.convert_to_score(comparison)
                # Stabilize score and calculate total player's score.
                scores[player_id] = score_controller.process_score(player_id, score, current_time)

        game_manager.update_score(scores)

        if game_manager.should_terminate():
            break
