import pickle


class Song:
    def __init__(self, song_name, angles, target_fps, pose_sequences):

        self.song_name = song_name
        self.pose_sequences = pose_sequences
        self.angles = angles
        self.fps = target_fps

    def get_closest_sequence(self, player_angle):
        """
        Return the pose sequence that best matches the player's camera angle.
        Args:
            player_angle: float
                The angle of the player's camera, ranged from 0 to 1.
                (ranged from 0 to 1, where 0 means camera on the ground, and 1 means camera above dancer).
        """
        closest_angle, closest_sequence = min(zip(self.angles, self.pose_sequences),
                                              key=lambda x: abs(player_angle - x[0]))

        # Print the chosen angle
        print(f"[LOG] Chosen angle: {closest_angle:.4f}")

        return closest_sequence

    def save_song(self):
        """
        Saves this instance to the collection of songs.
        """
        with open(f'./{self.song_name}.pkl', 'wb') as file:
            pickle.dump(self, file)

    @staticmethod
    def load_from(store_file):
        """
        Loads a Song from a file.
        Args:
            store_file: the path for the file.

        Returns: the loaded song.

        """
        with open(store_file, 'rb') as file:
            attributes = pickle.load(file)

        return Song(song_name=attributes['song-name'],
                    angles=attributes['angles'],
                    target_fps=attributes['fps'],
                    pose_sequences=attributes['pose-sequences'])


# EXAMPLE USAGE: Initialize a song and save it:
#
# model_path = '../Inference/weights/vitpose-b-coco.pth'
# yolo_path = '../Inference/weights/yolov5su.pt'
# model = VitInference(model_path, yolo_path)
#
# song = Song(model, "seven-rings", "MOV", angles=[0, 0.4, 0.6, 0.8], src_path="./Take1",
#             target_fps=10, duration=75)
# song.save_song()
