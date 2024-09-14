from Inference.vit_inference import VitInference
import pickle
import time
import cv2
from moviepy.editor import VideoFileClip


class Song:
    def __init__(self, song_name, file_suffix, angles, src_path, target_fps, duration):
        """
        Args:
            song_name: String
                the name of the song to be saved as.
            file_suffix: String
                The format type of the video from which the pose sequences will be extracted (mov or mp4 for instance).
            angles: List
                The angles in which the dance was filmed
                (ranged from 0 to 1, where 0 means camera on the ground, and 1 means camera above dancer).
            src_path: String
                The path to the videos of the dance.
            target_fps: int
                The fps in which the songs will be processed and saved.
            duration: float
                The duration of the dance in seconds.
        """
        self.song_name = song_name
        self.pose_sequences = []
        self.angles = angles
        self.fps = target_fps

        for i, angle in enumerate(angles):
            vid_path = f"{src_path}/{song_name}{i}.{file_suffix}"
            print(f"\n[LOG] GENERATING SONG {vid_path}...")

            pose_sequence = Song.get_pose_sequence_from_vid(vid_path, target_fps=target_fps, duration=duration)
            self.pose_sequences.append(pose_sequence)

    # TODO: Comment out this function, and the import of moviepy.editor, when using PyInstaller.
    #       (To avoid the redundant import of moviepy into the executable).
    @staticmethod
    def get_pose_sequence_from_vid(vid_path, target_fps, duration):
        """
        Process song video and initialize the pose sequence.
        Args:
            vid_path: String
                The path to the video of the dance.
            target_fps: int
                The fps in which the dance will be processed and saved.
            duration: float
                The duration of the dance in seconds.
        """
        model_path = './Inference/weights/vitpose-b-coco.pth'
        yolo_path = './Inference/weights/yolov5su.pt'

        model = VitInference(model_path, yolo_path)

        clip = VideoFileClip(vid_path)

        # Cut to only first 'duration' seconds and set fps.
        clip = clip.subclip(0, duration)
        new_clip = clip.set_fps(target_fps)
        frames = new_clip.iter_frames()
        frame_count, total_frames = 1, int(target_fps * new_clip.duration)
        result = []

        start_time = time.time()  # Start timing for ETA calculation

        for frame in frames:
            # Process frame and track time
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frame = cv2.flip(frame, 1)
            keypoints = model.inference(frame)
            result.append(next(iter(keypoints.values())))
            frame_count += 1

            # Calculate elapsed time and estimate remaining time
            elapsed_time = time.time() - start_time
            avg_frame_time = elapsed_time / frame_count
            remaining_frames = total_frames - frame_count
            eta = remaining_frames * avg_frame_time

            # Print progress with ETA
            print(f"\r[WORKING] Frame {frame_count}/{total_frames}. ETA: {int(eta)} seconds", end='', flush=True)

        print()
        return result

    def get_closest_sequence(self, player_angle):
        """
        Return the pose sequence that best matches the player's camera angle.
        Args:
            player_angle: float
                The angle of the player's camera, ranged from 0 to 1.
                (ranged from 0 to 1, where 0 means camera on the ground, and 1 means camera above dancer).

        """
        return min(zip(self.angles, self.pose_sequences), key=lambda x: abs(player_angle - x[0]))[1]

    def save_song(self):
        """
        Saves this instance to the collection of songs.
        """
        with open(f'./Songs/{self.song_name}.pkl', 'wb') as file:
            pickle.dump(self, file)

# EXAMPLE USAGE: Initialize a song and save it:
# song = Song("seven_rings", "mov", angles=[0, 0.3, 0.6, 1], src_path="./Songs/DanceFilms/",
#             target_fps=10, duration=120)
# song.save_song()
