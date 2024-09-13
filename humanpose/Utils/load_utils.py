import pickle


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
    return load_from(f"./Songs/{song_title}.pkl")
