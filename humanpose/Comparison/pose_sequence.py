import numpy as np
from Comparison.pose import Pose


class PoseSequence:
    def __init__(self, poses, fps):
        """
        Args:
            poses : list
                A list of poses where each pose is represented by keypoints.
            fps : int
                Frames per second of the pose sequence.
        """
        self.poses = np.array(poses)
        self.preprocessed_poses = None
        self.fps = fps

    def duration(self) -> float:
        """
        Returns the duration of the sequence in seconds.

        Returns:
            float
                The duration of the sequence in seconds.
        """
        return len(self.poses) / self.fps

    def num_frames(self):
        """
        Returns:
            int
                number of frames in the sequence.
        """
        return len(self.poses)

    def duration_to_frames(self, duration):
        """
        Converts a duration in seconds to number of frames in the sequence.
        Args:
            duration: float
                The duration in seconds.
        Returns:
            int
                Number of frames.
        """
        return int(duration * self.fps)

    def preprocess_poses(self, preprocess_method):
        """
        Processes the target pose sequence for future comparing.
        Args:
            preprocess_method: function
                The pre-process method what will be used.
        """
        if self.preprocessed_poses is None:
            self.preprocessed_poses = []
            for pose in self.poses:
                self.preprocessed_poses.append(preprocess_method(Pose(pose)))

    def __iter__(self):
        return iter(self.poses)

    def get_pose_at(self, time):
        """
        Returns the pose corresponding to the given time.

        Args:
            time : float
                The time in seconds for which the corresponding pose is to be returned.

        Returns:
            array
                The pose corresponding to the given time.
        """

        if time < 0 or time >= self.duration():
            return None

        frame_index = int(time * self.fps)
        return self.poses[frame_index]

    def get_subsequence(self, time, window):
        """
        Returns a sublist of the sequence centered at the given time with a specified duration.

        Args:
            time : float
                The time in seconds where the middle of the sublist should be.
            window : float
                The duration of the sublist in seconds.

        Returns:
            list
                A sublist of poses centered at the given time with the specified duration.
        """
        if not isinstance(time, (int, float)):
            raise TypeError("Time must be an int or float")

        if not isinstance(window, (int, float)):
            raise TypeError("Window must be an int or float")

        assert self.preprocessed_poses is not None, "[ERROR] Poses are not preprocessed."

        total_frames = len(self.preprocessed_poses)
        window_frames = self.duration_to_frames(window)
        half_window_frames = window_frames // 2
        center_frame = int(time * self.fps)

        start_frame = min(max(center_frame - half_window_frames - 1, 0), total_frames - 1)
        end_frame = max(min(center_frame + half_window_frames, total_frames), 0)

        if start_frame >= end_frame:
            return self.preprocessed_poses[0:1]

        return self.preprocessed_poses[start_frame:end_frame]
