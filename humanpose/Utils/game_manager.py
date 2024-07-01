import threading
import cv2


class GameManager:
    """
    This class is responsible for the communication between the threads of the algorithm, and the flutter app.
    It includes crucial information about the game's state.
    """

    def __init__(self, inference_model):
        self.game_state_lock = threading.Lock()
        self.game_condition = threading.Condition(self.game_state_lock)
        self.game_started = False

        self.score_lock = threading.Lock()
        self.score_condition = threading.Condition(self.score_lock)
        self.last_score = None

        self.capture = None
        self.model = inference_model
        self.num_players = None
        self.players = None

    def init_camera(self):
        """
        Inits the camera resource for the game.
        """
        self.capture = cv2.VideoCapture(0)

    def start_game(self, players):
        """
        Notify the threads that the game should start.
        """
        self.players = players

        with self.game_condition:
            self.game_started = True
            self.game_condition.notify_all()

    def wait_for_game_start(self):
        """
        Waits until the game starts.
        """
        with self.game_condition:
            while not self.game_started:
                self.game_condition.wait()

    def end_game(self):
        """
        End the game and notify the threads.
        """
        with self.game_condition:
            self.game_started = False
            self.game_condition.notify_all()

    def should_terminate(self):
        """
        Check if the game has ended and the threads should terminate.
        """
        with self.game_state_lock:
            return not self.game_started

    def get_score(self):
        """
        Receives the last calculated score.
        Also sets last score to be None, to avoid additional fetching of the same score.
        This function blocks until the last_score is not None.
        """
        with self.score_condition:
            if self.last_score is None:
                self.score_condition.wait()
            score = self.last_score
            self.last_score = None
            return score

    def get_players(self):
        """
        Returns which tracker indexes are the current players.
        """
        return self.players

    def update_score(self, score):
        """
        Updates last score with the most recent one and notifies the waiting thread.
        Args:
            score: the new score.
        """
        with self.score_condition:
            self.last_score = score
            self.score_condition.notify_all()

    def get_inference_model(self):
        """
        Returns a reference to the machine learning model that is being used.
        """
        return self.model

    def get_camera_access(self):
        """
        Returns a reference of the camera resource.
        """
        return self.capture

    def reset(self):
        """
        Resets the game manager for the next game.
        Should be called after every cancellation or termination of a game.
        """
        self.players = None
        self.num_players = None
        self.capture.release()
        self.capture = None
        cv2.destroyAllWindows()

        with self.game_state_lock:
            self.game_started = False

        with self.score_lock:
            self.last_score = None
