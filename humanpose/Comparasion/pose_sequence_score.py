import warnings

import numpy as np
from Comparasion.pose_sequence import PoseSequence
from Comparasion.pose_score import PoseScore
from Comparasion.angular_score import AngularScore
from Comparasion.cosine_pose import CosineScore


class PoseSequenceScore:
    def __init__(self, pose_sequence, score_method, window_duration, weights_config):
        """
            Parameters:
            -----------
            pose_sequence : PoseSequence
                The sequence of target poses to compare against.
            score_method : string
                The scoring method used to compare poses.
            window_duration : float
                The window size in seconds for comparing poses around the given time.
            weights_config : dict
                The configs for weighting the scores based on their proximity to the given time.

        """
        assert isinstance(pose_sequence, PoseSequence)
        assert isinstance(score_method, PoseScore)
        assert score_method in ["angular", "cosine"]

        self.score_method = AngularScore(factor=4) if score_method == "angular" else CosineScore()

        self.window_duration = window_duration
        self.weights = self.init_weights(weights_config=weights_config,
                                         window_size=pose_sequence.duration_to_frames(duration=window_duration),
                                         fps=pose_sequence.fps)

        self.preprocessed_target = None
        self.target_poses = pose_sequence.preprocess_poses(preprocess_method=self.score_method.process_target)

    @staticmethod
    def init_weights(weights_config, window_size, fps):
        """
        Inits weights to punish matches that occurs on the edges of the window.
        If the player's pose was accurate, but delayed - decrease the score by some factor.

        Parameters:
            weights_config: dict
                configs for the weight initialization.
            window_size: int
                the number of frame in the window.
            fps: int
                the fps of the window's frame.
        """
        dont_punish = int(weights_config["dont_punish"] * fps)
        shift = int(weights_config["shift"] * fps)
        punish_factor = weights_config["punish_factor"] / fps

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
""" This includes:

    - dont_punish: float
        If the player have delay of less than {dont_punish} seconds. We will not punish the player's score.
        
    - shift: float
        The area (of {dont_punish} seconds) in the middle in which we will not punish the player's delay,
        will be shifted {shift} seconds to the right.
        
    - punish_factor: float
        Every second of delay will result in a punish of {punish_factor} points to the player's score.
"""

weights_config = {"dont_punish": 1, "shift": 0.5, "punish_factor": 5}
window_size = 15  # for 5 fps, window_size=15 means a window of 3 seconds.
weights = PoseSequenceScore.init_weights(weights_config, window_size, fps=5)
print(weights)
