import 'package:app/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/pages/game_start_page.dart';
import 'package:app/widgets/song_card.dart';
import 'package:app/widgets/settings_widget.dart';
import 'package:app/utils/service/service.pbgrpc.dart';
import 'package:app/utils/service/client.dart';
import 'package:app/widgets/alert_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AppStorage appStorage = AppStorage();

  late CarouselController _carouselController;
  late bool gameStarted = false;
  late double cameraAngle = 0.5;
  List<Song> songs = AppStorage().getSongs();

  List<String> playerNames = ['ava', 'susan'];
  late int numberOfPlayers = 2;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    _initializeSongs(); // Initialize the songs and load the best scores
  }

  Future<void> _initializeSongs() async {
    // Hard-coded song list
    final List<Song> loadedSongs = appStorage.getSongs();

    // Load best scores from SharedPreferences for each song
    for (var song in loadedSongs) {
      song.bestScores = await appStorage.loadBestScores(song.name);
    }

    setState(() {
      songs = loadedSongs;
    });
  }


  void updatePlayerSelections(List<String> selectedPlayers) {
    setState(() {
      playerNames = selectedPlayers;
      numberOfPlayers = selectedPlayers.length;
    });
  }

  void updateCameraAngle(double newAngle) {
    setState(() {
      cameraAngle = newAngle;
    });
  }

  void clearAllScores() {
    setState(() {
      songs = appStorage.getSongs();
    });
  }

  String updateAndSaveNewScore(String songName, String player, int score) {
    final List<Song> songsCopy = songs;
    String recordText = "";

    for (var song in songsCopy) {
      if(song.name == songName) {

        if((song.bestScores[player] ?? 0) < score) {
          song.bestScores[player] = score;
          setState(() { songs = songsCopy;});
          appStorage.saveBestScore(player, songName, score);
          recordText = "Personal Best!";
        }

        final maxScore = song.bestScores.isEmpty ? 0 : song.bestScores.values.reduce(max);
        if(maxScore <= score){ recordText = 'NEW RECORD!';}

        break;
      }
    }
    return recordText;
  }

  Future<void> _loadGameAndStart(BuildContext context, Song song) async {
    if (gameStarted) return;

    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setVolume(0.6);
    audioPlayer.play(
        AssetSource('sound-effects/game-start.mp3'));

    setState(() {
      gameStarted = true;
    });

    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setVolume(0.6);
    audioPlayer.play(AssetSource('sound-effects/game-start.mp3'));

    final gameRequest = GameRequest(
      songTitle: song.name,
      numberOfPlayers: numberOfPlayers,
      cameraAngle: cameraAngle,
      gameSpeed: 1,
    );

    ScoringPoseServiceClient(getClientChannel())
        .loadGame(gameRequest)
        .then((response) {
      if (response.status == "waiting") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameStartPage(
              numberOfPlayers: numberOfPlayers,
              playerNames: playerNames,
              songName: song.name,
              updateAndSaveNewScores: updateAndSaveNewScore,
            ),
          ),
        ).then((res) {
          setState(() {
            gameStarted = false;
          });
        });
      } else {
        gameStarted = false;
        _showError("How about a different one?",
            "The chosen song could not be found. But we promise, all songs are fun!");
      }
    });
  }

  void _showError(String title, String content) {
    AlertWidget.showError(
      context,
      AlertWidget(
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40.0),
        color: Colors.grey.shade800,
        title: title,
        content: content,
        duration: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset('assets/images/background.png', fit: BoxFit.cover),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              const double leftSectionWidth = 350.0;
              final double songListWidth = screenWidth - leftSectionWidth;

              return Row(
                children: [
                  SizedBox(
                    width: leftSectionWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Image.asset('assets/images/jd-logo.png', width: 150),
                        const SizedBox(height: 30),
                        SettingWidget(
                          updatePlayerSelections: updatePlayerSelections,
                          updateCameraAngle: updateCameraAngle,
                          clearAllScores: clearAllScores,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: songListWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (details.primaryDelta! > 0) {
                            _carouselController.previousPage();
                          } else if (details.primaryDelta! < 0) {
                            _carouselController.nextPage();
                          }
                        },
                        child: CarouselSlider.builder(
                          carouselController: _carouselController,
                          itemCount: songs.length,
                          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                            return SongCard(
                              title: songs[itemIndex].title,
                              artist: songs[itemIndex].artist,
                              bestScores: songs[itemIndex].bestScores,
                              difficulty: songs[itemIndex].difficulty,
                              imageUrl: songs[itemIndex].imageUrl,
                              onTap: () {
                                _loadGameAndStart(context, songs[itemIndex]);
                              },
                            );
                          },
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height,
                            viewportFraction: 0.8,
                            enlargeCenterPage: true,
                            aspectRatio: 1 / 1,
                            onPageChanged: (index, reason) {
                              AudioPlayer audioPlayer = AudioPlayer();
                              audioPlayer.setVolume(0.4);
                              audioPlayer.play(AssetSource('sound-effects/whoosh.mp3'));
                            },
                            scrollDirection: Axis.vertical,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
