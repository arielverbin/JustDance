import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  // Saving best scores (map of player names to scores)
  Future<void> saveBestScore(String character, int bestScores) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('best_$character', bestScores);
  }

  // Retrieving best scores
  Future<Map<String, int>> loadBestScores(List<String> players) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> bestScores = {};
    for (var player in players) {
      bestScores[player] = prefs.getInt('best_$player') ?? 0;
    }
    return bestScores;
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
