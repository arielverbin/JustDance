import warnings

import numpy as np
from Comparasion.pose_sequence import PoseSequence
from Comparasion.pose_score import PoseScore
from Comparasion.angular_score import AngularScore
from Comparasion.cosine_pose import CosineScore


class PoseSequenceScore:
    def __init__(self, target_poses, score_method, window_duration, weights_config):
        """
            Parameters:
            -----------
            target_poses : PoseSequence
                The sequence of target poses to compare against.
            score_method : string
                The scoring method used to compare poses.
            window_duration : float
                The window size in seconds for comparing poses around the given time.
            weights_config : dict
                The configs for weighting the scores based on their proximity to the given time.

        """
        assert isinstance(target_poses, PoseSequence)
        assert isinstance(score_method, PoseScore)
        assert score_method in ["angular", "cosine"]

        self.score_method = AngularScore(4) if score_method == "angular" else CosineScore()

        self.window_duration = window_duration
        self.weights = self.init_weights(weights_config, target_poses.duration_to_frames(duration=window_duration))

        self.preprocessed_target = None
        self.target_poses = target_poses.preprocess_poses(preprocess_method=self.score_method.process_target)

    @staticmethod
    def init_weights(weights_config, window_size):
        dont_punish = weights_config["dont_punish"]
        shift = weights_config["shift"]
        punish_factor = weights_config["punish_factor"]

        assert dont_punish <= window_size
        if shift >= dont_punish / 2:
            warnings.warn("\n\n[WARNING] middle of window is punished while calculating score.\n"
                          "The middle represents a perfect timing of the player and therefore should not be punished.\n"
                          "This warning occurs when (one of) the middle weights is not 0.\n\n")

        weights = np.zeros(window_size)
        middle_index = window_size // 2

        # Calculate the start and end indices of the dont_punish sub-array
        start_index = middle_index - dont_punish // 2 - shift
        end_index = start_index + dont_punish

        # Iterate through the weights array and apply the punish_factor
        for i in range(window_size):
            if i < start_index:
                weights[i] = (start_index - i) * punish_factor
            elif i >= end_index:
                weights[i] = (i - end_index + 1) * punish_factor

        return weights

    def compare(self, pose, time):
        """
        Calculating the weight between the given pose and poses around the given time.
        Each score will be given a weight according to their offset from the actual time.
        The weights will be calculated based on the bias and sigma. For instance, peak weight is on {time}-{bias}.

        The compare result will be the maximum between product of the scores with their corresponding weights.

        Args:
            pose: Pose
                The pose that will be scored.
            time: float
                The time in which the pose took place.
        Returns:
            float
                the similarity between the pose in the given time, to the sequence of poses in this given time.
        """
        window = self.target_poses.get_subsequence(time, self.window_duration)

        scores = []
        for target, weight in zip(window, self.weights):
            scores.append(self.score_method.compare(pose, target) + weight)

        return min(scores)


# Example usage

weights_config = {"dont_punish": 4, "shift": 3, "punish_factor": 1}
window_size = 20
weights = PoseSequenceScore.init_weights(weights_config, window_size)
print(weights)
