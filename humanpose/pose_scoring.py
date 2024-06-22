from Utils.load_utils import load_from
from Utils.game_manager import GameManager
from Utils.game_utils import track_players, score_dance

import threading
from Comparasion.pose_sequence import PoseSequence
from Comparasion.pose_sequence_score import PoseSequenceScore
from Score.score_controller import ScoreController
from Inference.vit_inference import VitInference
from grpc_service import service_pb2_grpc
from grpc_service import service_pb2
import time


class PoseScoringService(service_pb2_grpc.ScoringPoseService):

    def __init__(self):
        self.model_path = './weights/vitpose.pth'
        self.yolo_path = './weights/yolov5s.pt'
        self.model = None
        self.game_manager = None
        self.comparator = None
        self.score_controller = None
        self.pose_estimation_thread = None
        self.tracking_thread = None

    def loadService(self, request, context):
        """
        While app is starting, initialize the model.
        Returns:
            LoadStatus: load status ('success' if the loading was successful)
        """
        model_path = '../Inference/weights/vitpose-b-coco.pth'
        yolo_path = '../Inference/weights/yolov5su.pt'
        try:
            self.model = VitInference(model_path, yolo_path)
            self.game_manager = GameManager()

        except Exception as e:
            return service_pb2.LoadStatus(status=f"Error: {str(e)}")

        return service_pb2.LoadStatus(status="success")

    def loadGame(self, request, context):
        """
        After the player starts a game, load the dance data and initialize the comparing and scoring methods.
        Returns:
            GameStatus: status of game initialization ('running' if the game was loaded successfully)
        """
        song_title = request.songTitle
        num_players = request.numOfPlayers  # TODO: Handle players initialization.
        game_speed = request.gameSpeed  # TODO: Training mode: set gameplay speed.

        pose_sequence = load_from(f"./Songs/{song_title}.pkl")
        target_sequence = PoseSequence(pose_sequence, fps=10)
        weights_config = {"dont_punish": 2, "shift": 0.3, "punish_factor": 100}

        self.comparator = PoseSequenceScore(target_sequence, "angular", window_duration=3,
                                            weights_config=weights_config)
        self.score_controller = ScoreController()

        self.tracking_thread = threading.Thread(target=track_players, args=(self.model, self.game_manager))
        self.pose_estimation_thread = threading.Thread(target=score_dance, args=(self.model,
                                                                                 self.comparator,
                                                                                 self.score_controller,
                                                                                 self.game_manager))

        self.tracking_thread.start()
        self.pose_estimation_thread.start()

        time.sleep(0.5)
        self.game_manager.start_game()
        return service_pb2.GameStatus(status="running")

    def getScore(self, request, context):
        """
        Returns the scores for the players on the most recent frame (current score and total score for each player).
        """
        score = self.game_manager.get_score()
        score1 = score[1] if score[1] is not None else (0, 0)
        score2 = score[2] if score[2] is not None else (0, 0)

        return service_pb2.ScoreResponse(score1=score1[0],
                                         totalScore1=score1[1],
                                         score2=score2[0],
                                         totalScore2=score2[1])

    def endGame(self, request, context):
        """
        When the game is ended, terminate the threads, reset the game manager and the model.
        Returns:
            EndStatus: status of game termination ('success' if termination was successful).
        """
        self.game_manager.end_game()

        self.pose_estimation_thread.join()
        self.tracking_thread.join()

        self.game_manager.reset()
        self.model.reset()

        return service_pb2.EndStatus(status="success",
                                     winner=1,
                                     totalScore1=0,
                                     totalScore2=0)
