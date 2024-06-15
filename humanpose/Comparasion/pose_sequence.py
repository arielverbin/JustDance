import numpy as np
from Comparasion.pose import Pose


class PoseSequence:
    def __init__(self, poses, fps):
        """
        Parameters:
        -----------
        poses : list
            A list of poses where each pose is represented by keypoints.
        fps : int
            Frames per second of the pose sequence.
        """
        self.poses = np.array(poses)
        self.preprocessed_poses = None
        self.fps = fps

    def __len__(self):
        """
        Returns the duration of the sequence in seconds.

        Returns:
        --------
        float
            The duration of the sequence in seconds.
        """
        return len(self.poses) / self.fps

    def num_frames(self):
        return len(self.poses)

    def duration_to_frames(self, duration):
        return int(duration * self.fps)

    def preprocess_poses(self, preprocess_method):
        self.preprocessed_poses = []
        for pose in self.poses:
            self.preprocessed_poses.append(preprocess_method(pose))

    def __iter__(self):
        return iter(self.poses)

    def __getitem__(self, time):
        """
        Returns the pose corresponding to the given time.

        Parameters:
        -----------
        time : float
            The time in seconds for which the corresponding pose is to be returned.

        Returns:
        --------
        Pose
            The pose corresponding to the given time.
        """

        if time < 0 or time >= self.__len__():
            return None

        frame_index = int(time * self.fps)
        return self.poses[frame_index]

    def get_subsequence(self, time, window):
        """
        Returns a sublist of the sequence centered at the given time with a specified duration.

        Parameters:
        -----------
        time : float
            The time in seconds where the middle of the sublist should be.
        window : float
            The duration of the sublist in seconds.

        Returns:
        --------
        list
            A sublist of poses centered at the given time with the specified duration.
        """
        if not isinstance(time, (int, float)):
            raise TypeError("Time must be an int or float")

        if not isinstance(window, (int, float)):
            raise TypeError("Window must be an int or float")

        assert not self.preprocessed_poses, "[ERROR] Poses are not preprocessed."

        total_frames = len(self.preprocessed_poses)
        window_frames = self.duration_to_frames(window)
        half_window_frames = window_frames // 2
        center_frame = int(time * self.fps)

        start_frame = max(center_frame - half_window_frames, 0)
        end_frame = min(center_frame + half_window_frames, total_frames)

        if start_frame >= end_frame:
            return PoseSequence([], fps=self.fps)

        return self.preprocessed_poses[start_frame:end_frame]
