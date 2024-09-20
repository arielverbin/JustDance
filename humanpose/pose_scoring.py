import time

from Utils.load_utils import load_from, load_song
from Utils.game_manager import GameManager
from Utils.game_utils import track_players, score_dance
from Utils.game_initializer import GameInitializer
import threading
from Comparasion.pose_sequence import PoseSequence
from Comparasion.pose_sequence_score import PoseSequenceScore
from Score.score_controller import ScoreController
from Inference.vit_inference import VitInference
from grpc_service import service_pb2_grpc
from grpc_service import service_pb2


class PoseScoringService(service_pb2_grpc.ScoringPoseService):

    def __init__(self):
        self.model = None
        self.game_manager = None
        self.comparator = None
        self.score_controller = None
        self.pose_estimation_thread = None
        self.tracking_thread = None
        self.game_init_thread = None
        self.game_initializer = None
        self.loaded = False
        self.score_controller = ScoreController(time_window=2)
        self.song_list = ["test_app_dance"]

        self.last_game_scores = None

    def loadService(self, request, context):
        """
        While app is starting, initialize the model.
        Returns:
            LoadStatus: load status ('success' if the loading was successful)
        """
        print(f"[LOG] Received loadService.")
        if not self.loaded:
            model_path = './Inference/weights/vitpose-b-coco.pth'
            yolo_path = './Inference/weights/yolov5su.pt'
            try:
                self.model = VitInference(model_path, yolo_path)
                self.game_manager = GameManager(inference_model=self.model)
                self.loaded = True
            except Exception as e:
                return service_pb2.LoadStatus(status=f"Error: {str(e)}")

        time.sleep(3)
        print(f"[LOG] DONE with loadService.")
        print("-----------------------------------------")
        return service_pb2.LoadStatus(status="success")

    def loadGame(self, request, context):
        """
        After the player starts a game, load the dance data and initialize the comparing and scoring methods.
        Returns:
            GameStatus: status of game initialization ('running' if the game was loaded successfully)
        """
        print(f"[LOG] Received loadGame. "
              f"Request: [numOfPlayers: {request.numberOfPlayers}, songTitle: {request.songTitle}]")

        if self.game_initializer is not None:
            self.end_game()

        song_title = request.songTitle  # request.songTitle
        num_players = request.numberOfPlayers
        self.game_manager.num_players = num_players  # TODO: Handle players initialization.
        # game_speed = request.gameSpeed  # TODO: Training mode: set gameplay speed.

        if song_title not in self.song_list:
            return service_pb2.GameStatus(numberOfPlayers=0, status="not found")

        pose_sequence = load_song(song_title, request.cameraAngle)
        print("done with this")

        target_sequence = PoseSequence(pose_sequence, fps=10)
        weights_config = {"dont_punish": 2, "shift": 0.3, "punish_factor": 100}

        self.comparator = PoseSequenceScore(target_sequence, "angular", window_duration=3,
                                            weights_config=weights_config)

        self.game_manager.init_camera()

        self.tracking_thread = threading.Thread(target=track_players, args=(self.game_manager,))
        self.pose_estimation_thread = threading.Thread(target=score_dance, args=(self.comparator,
                                                                                 self.score_controller,
                                                                                 self.game_manager))

        self.tracking_thread.start()
        self.pose_estimation_thread.start()

        self.game_initializer = GameInitializer(self.game_manager, num_players)
        self.game_init_thread = threading.Thread(target=self.game_initializer.init_game,
                                                 args=(GameInitializer.RAISING_HANDS_POSE,))

        self.game_init_thread.start()

        self.last_game_scores = None

        print(f"[LOG] DONE with loadGame.")
        print("-----------------------------------------")

        return service_pb2.GameStatus(numberOfPlayers=0, status="waiting")

    def startGame(self, request, context):
        """
        After game load, use this function to return information about the players (how many are raising their hands).
        The game will start when enough players are raising their hands, meanwhile, this function is used to get
        game status.
        This function can also be used to ask for game cancellation.
        """
        print(f"[LOG] Received startGame. Request: [{request.status}]")
        if request.status == 'cancel':
            self.game_initializer.cancel_game()

            self.pose_estimation_thread.join()
            self.tracking_thread.join()
            self.game_init_thread.join()
            self.end_game()

            print("[LOG] Canceling game...")
            return service_pb2.GameStatus(status="canceled")

        if self.game_initializer is None:
            print("[ERR] IN GAME-START: GAME IS NOT LOADED!")
            print("-----------------------------------------")
            return service_pb2.GameStatus(numberOfPlayers=0, status="game is not loaded")

        players, should_start = self.game_initializer.get_players_status()

        if should_start:
            self.game_init_thread.join()
            self.game_manager.start_game(players)
            print(f"\n\n\nGAME IS STARTING. PLAYERS: {self.game_manager.get_players()}")
            print("-----------------------------------------")
            return service_pb2.GameStatus(numberOfPlayers=len(players), status="ready")
        else:
            print("-----------------------------------------")
            return service_pb2.GameStatus(numberOfPlayers=len(players), status="waiting")

    def getScore(self, request, context):
        """
        Returns the scores for the players on the most recent frame (current score and total score for each player).
        """
        print(f"[LOG] Received getScore. Request: []")

        score1, score2 = self.fetch_scores(final=False)

        print(f"[LOG] DONE with getScore (score1={score1[0]}, totalScore1={score1[1]}, "
              f"score2={score2[0]}, totalScore2={score2[1]})")

        print("-----------------------------------------")
        return service_pb2.ScoreResponse(score1=int(score1[0]),
                                         totalScore1=int(score1[1]),
                                         score2=int(score2[0]),
                                         totalScore2=int(score2[1]))

    def endGame(self, request, context):
        """
        When the game is ended, terminate the threads, reset the game manager and the model.
        Returns:
            EndStatus: status of game termination ('success' if termination was successful).
        """
        print(f"[LOG] Received endGame. Request: []")

        score1, score2 = self.fetch_scores(final=True)

        self.end_game()
        winner = 0 if score1[1] > score2[1] else 1

        print(f"[LOG] DONE with endGame (winner: {winner}, totalScore1: {score1[1]}, totalScore2: {score2[1]})")
        print("-----------------------------------------")
        return service_pb2.EndStatus(status="success",
                                     winner=winner,
                                     totalScore1=score1[1],
                                     totalScore2=score2[1])

    def end_game(self):
        """
            Ends game and joins all open threads.
        """
        self.game_manager.end_game()

        self.game_initializer = None
        self.pose_estimation_thread.join()
        self.tracking_thread.join()
        self.game_init_thread.join()
        print("[LOG] Joined all threads.")

        self.game_manager.reset()
        self.model.reset()
        self.score_controller.reset()

    def fetch_scores(self, final=False):
        """
            Get the current player's scores.
            Args:
                final:  Whether the scores should be considered as final or not. If final is false,
                        the method will wait until new score arrives since last call.
            Returns:
                two tuples, each tuple contains a player's last and total score.
        """
        players = self.game_manager.get_players()

        if self.last_game_scores is not None:  # Game was already ended, game_manager might have been already reset.
            score = self.last_game_scores
        elif not final:
            score = self.game_manager.get_score()  # Game is running, fetch last scores.
        else:
            score = self.game_manager.get_final_score()  # Game just ended. get final score and update last_game_scores.
            self.last_game_scores = score

        p1 = players[0]
        p2 = players[1] if len(players) > 1 and players[1] is not None else None
        score1 = score[p1] if score[p1] is not None else (0, 0)
        score2 = score[p2] if p2 is not None else (0, 0)

        print(f"Player1 is with ID: {p1}, Player2 is with ID: {p2}")

        return score1, score2
