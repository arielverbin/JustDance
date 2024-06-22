import threading


class GameManager:
    """
    This class is responsible for the communication between the threads of the algorithm, and the flutter app.
    """

    def __init__(self):
        self.game_state_lock = threading.Lock()
        self.game_condition = threading.Condition(self.game_state_lock)
        self.game_started = False

        self.score_lock = threading.Lock()
        self.score_condition = threading.Condition(self.score_lock)
        self.last_score = None

    def start_game(self):
        """
        Notify the threads that the game should start.
        """
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

    def update_score(self, score):
        """
        Updates last score with the most recent one and notifies the waiting thread.
        Args:
            score: the new score.
        """
        with self.score_condition:
            self.last_score = score
            self.score_condition.notify_all()

    def reset(self):
        """
        Resets the game manager for the next game.
        """
        with self.game_state_lock:
            self.game_started = False

        with self.score_lock:
            self.last_score = None
