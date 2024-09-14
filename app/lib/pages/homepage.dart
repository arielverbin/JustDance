import 'dart:async';

import 'package:app/pages/game_start_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/widgets/song_card.dart';
import 'package:app/widgets/settings_widget.dart';
import 'package:app/utils/service/service.pbgrpc.dart';
import 'package:app/utils/service/client.dart';
import 'package:app/widgets/alert_widget.dart';
import 'package:audioplayers/audioplayers.dart';

class Song {
  String title;
  String artist;
  Map<String, int> bestScores;
  String imageUrl;
  String name;
  int difficulty;

  Song(this.title, this.artist, this.bestScores, this.imageUrl, this.name,
      this.difficulty);
}

// TODO: add delay to start game right after camera preview was used (to let camera turn off).

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<HomePageState> _homepageKey = GlobalKey();
  late CarouselController _carouselController;
  late bool gameStarted = false;
  late double cameraAngle = 0.5;

  late int numberOfPlayers;
  List<String> playerNames = ['ava'];


  @override
  void initState() {
    super.initState();
    numberOfPlayers = 1;
    _carouselController = CarouselController();
  }

  void updatePlayerSelections(List<String> selectedPlayers) {
    setState(() {
      playerNames = selectedPlayers;
      numberOfPlayers = selectedPlayers.length;
      print(playerNames);
      print(numberOfPlayers);
    });
  }

  void updateCameraAngle(double newAngle) {
    setState(() {
      cameraAngle = newAngle;
      print(cameraAngle);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showError(String title, String content) {
    AlertWidget.showError(
      context,
      AlertWidget(
        icon: const Icon(Icons.warning_amber_rounded,
            color: Colors.white, size: 40.0),
        color: Colors.grey.shade800,
        title: title,
        content: content,
        duration: 2,
      ),
    );
  }

  Future<void> _loadGameAndStart(BuildContext context, Song song) async {
    if (gameStarted) return;

    setState(() {
      gameStarted = true;
    });

    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setVolume(0.6);
    audioPlayer.play(
        AssetSource('sound-effects/game-start.mp3'));

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
        // loading succeeded, game is waiting for players.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameStartPage(
              numberOfPlayers: numberOfPlayers,
              playerNames: playerNames,
              songName: song.name,
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

  @override
  Widget build(BuildContext context) {
    // The list of songs for the carousel
    final List<Song> songs = [
      Song(
          'Unicorn',
          'Noa Kirel',
          {'susan': 342, 'noah': 3491, 'emily': 1904, 'ava': 301},
          'assets/images/background.png',
          "unicorn",
          2),
      Song(
          'Flowers',
          'Miley Cirus',
          {'caleb': 3412, 'noah': 529, 'susan': 2312},
          'assets/images/background.png',
          "flowers",
          3),
      Song(
          'Starships',
          'Nicky Minaj',
          {'susan': 4023, 'noah': 3491, 'emily': 523, 'liam': 420, 'ava': 3021},
          'assets/images/background.png',
          "starships",
          4),
      Song(
          'Test App',
          'Just Dance Team',
          {
            'susan': 1702,
            'noah': 2034,
            'emily': 1573,
            'liam': 1813,
            'ava': 3913
          },
          'assets/images/background.png',
          "test_app_dance",
          1),
    ];

    return Scaffold(
      key: _homepageKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // LayoutBuilder to adjust the space for the song list and the menu
          LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              const double leftSectionWidth = 350.0;
              final double songListWidth = screenWidth - leftSectionWidth;

              return Row(
                children: [
                  // Left menu (350 pixels wide)
                  SizedBox(
                    width: leftSectionWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          'assets/images/jd-logo.png',
                          width: 150, // Adjust logo size
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SettingWidget(
                            updatePlayerSelections: updatePlayerSelections,
                            updateCameraAngle: updateCameraAngle,
                        ),
                      ],
                    ),
                  ),

                  // Scrollable song list takes up the remaining width
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
                          itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) {
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
                              audioPlayer.play(
                                  AssetSource('sound-effects/whoosh.mp3'));
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

