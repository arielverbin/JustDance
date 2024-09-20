import threading
import time

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
        self.game_canceled = False

        self.score_lock = threading.Lock()
        self.score_condition = threading.Condition(self.score_lock)
        self.last_score = None  # Resets to None whenever it is accessed (to prevent accessing the same score twice)
        self.final_score = None  # Does not reset to None (fetch last score).

        self.game_speed = 1

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
            self.game_canceled = False
            self.game_condition.notify_all()

    def wait_for_game_start(self):
        """
        Waits until the game starts.
        """
        with self.game_condition:
            while (not self.game_started) and (not self.game_canceled):
                self.game_condition.wait()

    def end_game(self):
        """
        End the game and notify the threads.
        """
        with self.game_condition:
            self.game_started = True
            self.game_canceled = True
            self.game_condition.notify_all()

    def cancel_game(self):
        """
        Checks whether the game was canceled or not.
        """
        with self.game_condition:
            self.game_started = False
            self.game_canceled = True
            self.game_condition.notify_all()

    def did_game_end(self):
        """
        Checks whether the game ended or not.
        """
        with self.game_condition:
            return not self.game_started

    def should_terminate(self):
        """
        Check if the game has ended and the threads should terminate.
        """
        with self.game_condition:
            return (not self.game_started) or self.game_canceled

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

    def get_final_score(self):
        """
        Gets the final scores of each player at the end of the game.
        """
        with self.score_condition:
            return self.final_score

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
            self.final_score = score
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

        if self.capture is not None:
            self.capture.release()
            self.capture = None
            cv2.destroyAllWindows()
            time.sleep(0.5)  # Wait a bit until camera is fully released.

        with self.game_state_lock:
            self.game_started = False
            self.game_canceled = False

        with self.score_lock:
            self.last_score = None
            self.final_score = None
