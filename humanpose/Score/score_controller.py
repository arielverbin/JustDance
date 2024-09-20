class ScoreController:

    def __init__(self, time_window):
        self.players = {}
        self.time_window = time_window  # Keep scores within the last {time_window} seconds

    def reset(self):
        self.players = {}

    def process_score(self, player_id, score, time):
        """
        Calculates the stabilized and total score of a given player.
        Returns:
            The current score after stabilization, and the total score so far.
        """

        if player_id not in self.players:
            self.players[player_id] = {
                'scores': [(score, time)],  # Store (score, timestamp)
                'last_score': score,
                'last_time': time,
                'total_score': 0.0,
            }
            return 0.0, score

        self._update_total_score(player_id, score, time)
        self.players[player_id]['last_score'] = score
        self.players[player_id]['last_time'] = time

        # Clean up old scores based on time
        self._remove_old_scores(player_id, time)

        stabilized_score = self._calculate_stabilized_score(player_id, score)

        # Add the new score with its time
        self._push_new_score(player_id, score, time)

        return int(stabilized_score), int(self.players[player_id]['total_score'])

    def _push_new_score(self, player_id, score, time):
        scores = self.players[player_id]['scores']
        scores.append((score, time))

    def _remove_old_scores(self, player_id, current_time):
        """
        Removes scores that are outside the time window (older than 2 seconds).
        """
        self.players[player_id]['scores'] = [
            (s, t) for (s, t) in self.players[player_id]['scores']
            if current_time - t <= self.time_window + 1e-5
        ]

    def _update_total_score(self, player_id, score, time):
        """
        Update total score by linear approximation.
        """
        last_score = self.players[player_id]['last_score']
        last_time = self.players[player_id]['last_time']
        self.players[player_id]['total_score'] += (
            ((score + last_score) / 2) * (time - last_time)
        )

    def _calculate_stabilized_score(self, player_id, score):
        """
        Calculate the stabilized score using the weighted sum of recent scores
        within the time window and the new score.
        """
        scores = self.players[player_id]['scores']
        if len(scores) == 0:
            return score

        # Extract just the scores from the tuples (ignoring time for now)
        recent_scores = [s for s, _ in scores]

        return 0.5 * (sum(recent_scores) / len(recent_scores)) + 0.5 * score
