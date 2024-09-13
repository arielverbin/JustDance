import cv2
import time
from Comparasion.pose import Pose


def track_players(game_manager):
    """
    Works on its own thread. Responsible for accessing the camera and tracking the players.
    Args:
        game_manager: used to contact with the other threads.
    """
    model = game_manager.get_inference_model()
    players = None
    capture = game_manager.get_camera_access()
    # TODO: this thread is active on gameStart. change it so THIS thread will do the tracking
    while True:
        ret, img = capture.read()

        game_manager.wait_for_game_start()
        if game_manager.should_terminate():
            break

        if players is None:
            players = game_manager.get_players()

        if not ret:
            print("Error: Could not read frame from camera.")
            break
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img = cv2.flip(img, 1)

        model.update_tracker(img, protect=players)

        if cv2.waitKey(1) & 0xFF == ord("q"):
            break

    cv2.destroyAllWindows()


def score_dance(comparator, score_controller, game_manager):
    """
    Works on its own thread. Responsible for performing the human pose estimation and calculating the score.
    Args:
        comparator: the comparator method.
        score_controller: the method for stabilizing the score and calculating the total score.
        game_manager: used to contact with the other threads.
    """
    model = game_manager.get_inference_model()

    players = None
    start_time = None

    while True:

        # Waits for game to start.
        game_manager.wait_for_game_start()

        if game_manager.should_terminate():
            break

        if players is None:
            players = game_manager.get_players()

        # Inference keypoints of every person in the frame.
        keypoints = model.inference()

        if start_time is None:
            start_time = time.time()

        current_time = time.time() - start_time

        scores = {}
        # print(f"DETECTED PLAYERS: {keypoints.keys()}, PLAYERS: {players}")
        # print(f"KEYPOINTS: {keypoints}\n\n\n")
        if keypoints:
            for player_id, current_pose in keypoints.items():
                print(f"Person {player_id} detected.")
                if player_id in players:
                    print(f"Nose X,Y for player ID{player_id}: ({current_pose[0][1]:.4f}, {current_pose[0][0]}:.4f)")
                    # Calculate comparison value.
                    comparison = comparator.compare(pose=Pose(current_pose), time=current_time, preprocessed=False)
                    # Convert comparison value to score.
                    score = comparator.convert_to_score(comparison)
                    # Stabilize score and calculate total player's score.
                    scores[player_id] = score_controller.process_score(player_id, score, current_time)

        # For every player that was missed, give them a score of 0.
        # TODO: maybe give them average?
        if len(scores) != len(players):
            for player_id in players:
                if player_id not in scores:
                    scores[player_id] = score_controller.process_score(player_id, 0, current_time)

        # print(f"final scores: {scores}")
        game_manager.update_score(scores)

