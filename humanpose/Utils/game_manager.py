import threading


class GameManager:

    def __init__(self):
        self.lock = threading.Lock()
        self.condition = threading.Condition(self.lock)
        self.game_started = False
        self.last_score = None

    def start_game(self):
        with self.condition:
            self.game_started = True
            self.condition.notify_all()

    def wait_for_game_start(self):
        with self.condition:
            while not self.game_started:
                self.condition.wait()

    def end_game(self):
        with self.condition:
            self.game_started = False
            self.condition.notify_all()

    def should_terminate(self):
        with self.lock:
            return not self.game_started

    def get_score(self):
        with self.lock:
            return self.last_score

    def update_score(self, score):
        with self.lock:
            self.last_score = score

    def reset(self):
        with self.lock:
            self.last_score = None
