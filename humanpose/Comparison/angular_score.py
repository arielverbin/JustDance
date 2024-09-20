import numpy as np
from Comparison.utils import calc_angle, weighted_avg
from Comparison.pose_score import PoseScore

joints = [
    [16, 14, 12, 0.7],  # Knee 1
    [15, 13, 11, 0.7],  # Knee 2
    [14, 12, 11, 0.7],  # Lower Hip 1
    [13, 11, 12, 0.7],  # Lower Hip 2
    [6, 12, 14, 0.5],  # Outer Hip 1
    [5, 11, 13, 0.5],  # Outer Hip 2
    [6, 12, 11, 0.5],  # Upper Hip 1
    [5, 11, 12, 0.5],  # Upper Hip 2

    [8, 6, 12, 1],  # Lower Shoulder-Arm 1
    [7, 5, 11, 1],  # Lower Shoulder-Arm 2
    [12, 6, 5, 0.7],  # Inner Shoulder 1
    [11, 5, 6, 0.7],  # Inner Shoulder 2
    [8, 6, 0, 1],  # Outer Shoulder 1
    [7, 5, 0, 1],  # Outer Shoulder 2

    [10, 8, 6, 1],  # Arm 1
    [9, 7, 5, 1],  # Arm 2

    [0, 6, 5, 0.5],  # Nose-Shoulder 1
    [0, 5, 6, 0.5],  # Nose-Shoulder 2
    [6, 0, 5, 0.3],  # Nose-Shoulders

    [1, 2, 0, 0.1],  # Eye-Nose 1
    [2, 1, 0, 0.1],  # Eye-Nose 2
    [2, 0, 1, 0.1],  # Eyes-Nose

    [1, 2, 4, 0.1],  # Eye-Ear 1
    [2, 1, 3, 0.1],  # Eye-Ear 2
]


class AngularScore(PoseScore):
    def __init__(self, factor):
        self.factor = factor
        self.angles_weights = np.array(joints)[:, 3]

    def process_target(self, target_pose):
        v1 = target_pose.get_coordinates()
        processed_target = []
        for joint in joints:
            angle = calc_angle((v1[joint[0]], v1[joint[1]]),
                               (v1[joint[1]], v1[joint[2]]))
            processed_target.append(angle)

        return processed_target

    def compare(self, preprocessed_target, pose):
        """
            Compares the two poses using the angular method.
            Returns:
                (float): the comparison result (where 0 is best).
        """

        v2 = pose.get_coordinates()
        scores = []

        joint_count = 0
        for joint in joints:
            angle1 = preprocessed_target[joint_count]
            joint_count = joint_count + 1

            angle2 = calc_angle((v2[joint[0]], v2[joint[1]]),
                                (v2[joint[1]], v2[joint[2]]))

            angle_diff = abs(angle1 - angle2)

            scores.append(angle_diff ** self.factor)

        # TODO: use weighted mean instead of normal mean
        #  (according to probabilities - after softmax - and importance of each joint).
        score = weighted_avg(scores, self.angles_weights) ** (1 / self.factor)

        return score

    def compare_preprocessed(self, preprocessed_target, preprocessed_pose):
        """
            Compares the two preprocessed poses using the angular method.
            Returns:
                (float): the comparison result (where 0 is best).
        """
        scores = []

        for i in range(len(joints)):
            angle1 = preprocessed_target[i]
            angle2 = preprocessed_pose[i]

            angle_diff = abs(angle1 - angle2)

            scores.append(angle_diff ** self.factor)

        # TODO: use weighted mean instead of normal mean
        #  (according to probabilities - after softmax - and importance of each joint).
        score = weighted_avg(scores, self.angles_weights) ** (1 / self.factor)

        return score

    def convert_to_score(self, value):
        """
            Convert a comparison value to a score.
            Args:
                value (float): the comparison value (in scale of (0,~70) where 0 is best).
            Returns:
                (int): the score between 100 and 0.
        """
        if value < 15:
            return 100  # Excellent
        if value < 20:
            return 90  # Great
        if value < 25:
            return 70  # Good
        if value < 30:
            return 50  # OK
        if value < 40:
            return 10  # Nah

        return 0  # X
