import numpy as np
from Comparasion.pose_score import PoseScore


class CosineScore(PoseScore):

    def compare(self, preprocessed_target, pose):
        """
            Compares the two poses using the cosine similarity method.
            Returns:
                (float): the comparison result between -1 and 1 (where 0 is best).
        """

        v2 = pose.get_coordinates().flatten()
        cos_sim = np.dot(preprocessed_target, v2) / (np.linalg.norm(preprocessed_target) * np.linalg.norm(v2))

        return cos_sim

    def convert_to_score(self, value):
        score = (value ** 2) * 100  # Transform the score to [0,100]
        return 100 - score

    def process_target(self, target_pose):
        return target_pose.get_coordinates().flatten()
