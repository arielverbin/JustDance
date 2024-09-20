from Songs.song import Song  # Don't remove this import! load_song needs it implicitly.


def load_song(song_title, player_angle):
    """
    Loads a song instance and returns the pose sequences that best matches the player angle.
    """
    print(f"[LOG] loading ./Songs/{song_title}.pkl...")
    song = Song.load_from(f"./Songs/{song_title}.pkl")

    return song.get_closest_sequence(player_angle)
