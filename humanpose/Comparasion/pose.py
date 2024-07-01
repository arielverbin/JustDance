import numpy as np


class Pose:
    def __init__(self, keypoints):
        self.keypoints = np.array(keypoints)
        self.coordinates = None
        self.probabilities = None

    def get_coordinates(self):
        """
            Extracts only the coordinates from the pose (removes the confidence scores).
        """
        if self.coordinates is None:
            self.coordinates = self.keypoints[:, :2]
        return self.coordinates

    def get_probabilities(self):
        """
            Extracts only the confidence scores from the pose (removes the coordinates).
        """
        if self.probabilities is None:
            self.probabilities = self.keypoints[:, 2]
        return self.probabilities

    def l2_normalize(self):
        coords = self.coordinates  # Extract x and y coordinates
        probabilities = self.probabilities  # Extract probabilities

        # Calculate L2 norms for each set of coordinates
        l2_norms = np.linalg.norm(coords, axis=1, keepdims=True)

        # Avoid division by zero by replacing zero norms with one
        l2_norms[l2_norms == 0] = 1

        # Normalize coordinates
        normalized_coords = coords / l2_norms
        self.coordinates = normalized_coords

        # Combine normalized coordinates with original probabilities
        normalized_arr = np.hstack((normalized_coords, probabilities.reshape(-1, 1)))

        self.keypoints = normalized_arr
        return self
