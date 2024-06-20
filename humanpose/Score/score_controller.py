class ScoreController:

    def __init__(self):
        self.players = {}

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
                'scores': [score],
                'last_score': score,
                'last_time': time,
                'total_score': 0.0,
            }
            return 0.0, score

        self._update_total_score(player_id, score, time)

        self.players[player_id]['last_score'] = score
        self.players[player_id]['last_time'] = time

        stabilized_score = self._calculate_stabilized_score(player_id, score)

        self._push_new_score(player_id, score)

        return int(stabilized_score),  int(self.players[player_id]['total_score'])

    def _push_new_score(self, player_id, score):
        scores = self.players[player_id]['scores']
        scores.append(score)
        if len(scores) > 4:
            scores.pop(0)

    def _update_total_score(self, player_id, score, time):
        last_score = self.players[player_id]['last_score']
        last_time = self.players[player_id]['last_time']

        self.players[player_id]['total_score'] += (((score + last_score) / 2) * (time - last_time))

    def _calculate_stabilized_score(self, player_id, score):
        """
        Calculate the stabilized score using the weighted sum of the last 4 scores and the new score.
        """
        scores = self.players[player_id]['scores']
        if len(scores) == 0:
            return score

        return 0.5 * (sum(scores) / len(scores)) + 0.5 * score
