import 'package:shared_preferences/shared_preferences.dart';

class Song {
  String title;
  String artist;
  Map<String, int> bestScores;
  String imageUrl;
  String name;
  int difficulty;

  Song(this.title, this.artist, this.bestScores, this.imageUrl, this.name, this.difficulty);
}

class AppStorage {

  List<Song> getSongs() {
    return [
      Song('Test App', 'Just Dance Team', {}, 'assets/images/test-app.png', "test-app", 1),
      Song('Unicorn', 'Noa Kirel', {}, 'assets/images/background.png', "unicorn", 2),
      Song('Seven Rings', 'Ariana Grande', {}, 'assets/images/seven-rings.png', "seven-rings", 3),
      Song('Starships', 'Nicky Minaj', {}, 'assets/images/background.png', "starships", 4),
    ];
  }

  List<String> getPlayers() {
    return [
      'ava', 'caleb', 'emily', 'liam', 'noah', 'susan'
    ];
  }

  // Save best score for a specific player and a specific song
  Future<void> saveBestScore(String player, String song, int newScore) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'best_${player}_$song';

    // Retrieve the current best score
    int currentBestScore = prefs.getInt(key) ?? 0; // Default to 0 if no score found

    // Update the score only if the new score is higher
    if (newScore > currentBestScore) {
      await prefs.setInt(key, newScore);
    }
  }

  // Retrieving best scores
  Future<Map<String, int>> loadBestScores(String song) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> bestScores = {};

    final players = getPlayers();

    for (var player in players) {
      String key = 'best_${player}_$song';
      int playerScore = prefs.getInt(key) ?? 0;
      if(playerScore != 0) {
        bestScores[player] = playerScore;
      }
    }

    return bestScores;
  }

  // Load best score for a specific player in a specific song
  Future<int> loadBestScore(String player, String song) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'best_${player}_$song';
    return prefs.getInt(key) ?? 0; // Return 0 if no score is found
  }

  // Saving chosen characters (two strings)
  Future<void> saveChosenCharacters(String player1, String player2) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('character_1', player1);
    await prefs.setString('character_2', player2);
  }

  // Retrieving chosen characters
  Future<List<String>> loadChosenCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    String player1 = prefs.getString('character_1') ?? 'ava';
    String player2 = prefs.getString('character_2') ?? 'none';
    return [player1, player2];
  }

  // Saving camera angle setting (float)
  Future<void> saveCameraAngle(double cameraAngle) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('camera_angle', cameraAngle);
  }

  // Retrieving camera angle setting
  Future<double> loadCameraAngle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('camera_angle') ?? 0.5;
  }

  // Clear all storage.
  Future<void> clearStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
