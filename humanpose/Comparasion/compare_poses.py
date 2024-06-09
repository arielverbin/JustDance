import numpy as np
from Comparasion.utils import calc_angle
import math

joints = [
    [16, 14, 12],  # Knee 1
    [15, 13, 11],  # Knee 2
    [14, 12, 11],  # Lower Hip 1
    [13, 11, 12],  # Lower Hip 2
    [6, 12, 14],  # Outer Hip 1
    [5, 11, 13],  # Outer Hip 2
    [6, 12, 11],  # Upper Hip 1
    [5, 11, 12],  # Upper Hip 2

    [8, 6, 12],  # Lower Shoulder-Arm 1
    [7, 5, 11],  # Lower Shoulder-Arm 2
    [12, 6, 5],  # Inner Shoulder 1
    [11, 5, 6],  # Inner Shoulder 2
    [8, 6, 0],  # Outer Shoulder 1
    [7, 5, 0],  # Outer Shoulder 2

    [10, 8, 6],  # Arm 1
    [9, 7, 5],  # Arm 2

    [0, 6, 5],  # Nose-Shoulder 1
    [0, 5, 6],  # Nose-Shoulder 2
    [6, 0, 5],  # Nose-Shoulders

    #TODO: Add weights to anglers.

    # [1, 2, 0],  # Eye-Nose 1
    # [2, 1, 0],  # Eye-Nose 2
    # [2, 0, 1],  # Eyes-Nose
    #
    # [1, 2, 4],  # Eye-Ear 1
    # [2, 1, 3],  # Eye-Ear 2
]

scores = [100, 50, 0]


class Score:
    def __init__(self, pose1, pose2, score_method, factor):
        assert score_method in ["cosine", "angular"]

        # TODO: Add option to insert pose1 as pre-calculated angles/normalized.
        self.pose1 = np.array(pose1)
        self.pose2 = np.array(pose2)
        self.factor = factor
        self.calc_score = {
            "cosine": self.__cosine_similarity__,
            "angular": self.__angle_similarity__
        }[score_method]

    @staticmethod
    def l2_normalization(pose):
        coords = pose[:, :2]  # Extract x and y coordinates
        probabilities = pose[:, 2]  # Extract probabilities

        # Calculate L2 norms for each set of coordinates
        l2_norms = np.linalg.norm(coords, axis=1, keepdims=True)

        # Avoid division by zero by replacing zero norms with one
        l2_norms[l2_norms == 0] = 1

        # Normalize coordinates
        normalized_coords = coords / l2_norms

        # Combine normalized coordinates with original probabilities
        normalized_arr = np.hstack((normalized_coords, probabilities.reshape(-1, 1)))

        return normalized_arr

    @staticmethod
    def get_coordinates(pose):
        """
            Extracts only the coordinates from the pose (removes the confidence scores).
            Args:
                pose: the array of keypoints (where each keypoint is (x,y,p)).
            Returns:
                the array of coordinates (where each keypoints is (x,y)).
        """
        return pose[:, :2]

    @staticmethod
    def convert_to_score(value):
        """
            Convert a comparison value to a score.
            Args:
                value (float): the comparison value (in scale of (0,50) where 0 is best).
            Returns:
                (int): the score between 100 and 0.
        """
        if value < 10:
            return 100  # Excellent
        if value < 15:
            return 90   # Great
        if value < 20:
            return 70   # Good
        if value < 30:
            return 50   # OK
        if value < 40:
            return 20   # Nah
        if value < 50:
            return 10   # X

        return 0        # X

    def normalized_poses(self):
        """
            Normalizes the poses, so each keypoint (x,y) would satisfy x^2+y^2=1.
        """
        self.pose1 = Score.l2_normalization(self.pose1)
        self.pose2 = Score.l2_normalization(self.pose2)
        return self

    def __cosine_similarity__(self):
        """
            Compares the two poses using the cosine similarity method.
            Returns:
                (int): the score between 100 and 0.
        """
        v1 = Score.get_coordinates(self.pose1).flatten()
        v2 = Score.get_coordinates(self.pose2).flatten()
        cos_sim = np.dot(v1, v2) / (np.linalg.norm(v1) * np.linalg.norm(v2))
        cos_sim = (cos_sim ** 2) * 50  # Transform the score to [0,50]
        return Score.convert_to_score(cos_sim)

    def __angle_similarity__(self):
        """
            Compares the two poses using the angular method.
            Returns:
                (int): the score between 100 and 0.
        """
        v1 = Score.get_coordinates(self.pose1)
        v2 = Score.get_coordinates(self.pose2)
        scores = []
        for joint in joints:
            angle1 = calc_angle((v1[joint[0]], v1[joint[1]]),
                                (v1[joint[1]], v1[joint[2]]))

            angle2 = calc_angle((v2[joint[0]], v2[joint[1]]),
                                (v2[joint[1]], v2[joint[2]]))

            scores.append(abs(angle1 - angle2) ** self.factor)

        # TODO: use weighted mean instead of normal mean
        #  (according to probabilities - after softmax - and importance of each joint).
        score = np.mean(scores) ** (1 / self.factor)

        return self.convert_to_score(score)

    def get_score(self):
        """
            Calculates the similarity between the two poses and returns the score.
            Returns:
                (int): the score between 100 and 0.
        """
        return self.calc_score()
