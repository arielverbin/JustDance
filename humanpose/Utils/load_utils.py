import pickle
from Songs.song import Song  # Don't remove this import! load_song needs it implicitly.


def load_from(store_file):
    """
    Loads a pose sequence from a file.
    Args:
        store_file: the path for the file.

    Returns: the pose sequence as array of poses.

    """
    with open(store_file, 'rb') as file:
        return pickle.load(file)


def load_song(song_title, player_angle):
    """
    Loads a song instance and returns the pose sequences that best matches the player angle.
    """
    # song = load_from(f"./Songs/{song_title}.pkl")
    # return song.get_closest_sequence(player_angle)
    return load_from(f"./Songs/{song_title}.pkl")
