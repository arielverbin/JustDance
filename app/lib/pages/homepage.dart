import 'dart:async';

import 'package:app/pages/game_start_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/widgets/song_card.dart';
import 'package:app/widgets/settings_widget.dart';
import 'package:app/utils/service/service.pbgrpc.dart';
import 'package:app/utils/service/client.dart';
import 'package:app/widgets/alert_widget.dart';

class Song {
  String title;
  String artist;
  String bestScore;
  String imageUrl;
  String name;
  int difficulty;

  Song(this.title, this.artist, this.bestScore, this.imageUrl, this.name, this.difficulty);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<HomePageState> _homepageKey = GlobalKey();
  late CarouselController _carouselController;
  late int numberOfPlayers;
  late bool gameStarted = false;


  @override
  void initState() {
    super.initState();
    numberOfPlayers = 1;
    _carouselController = CarouselController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onNumberOfPlayersChanged(int newNumberOfPlayers) {
    setState(() {
      numberOfPlayers = newNumberOfPlayers;
    });
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
    if(gameStarted) return;

    setState(() { gameStarted = true; });
    final gameRequest = GameRequest(
      songTitle: song.name,
      numberOfPlayers: numberOfPlayers,
      gameSpeed: 1,
    );

    ScoringPoseServiceClient(getClientChannel()).loadGame(gameRequest)
        .then((response) {

      if (response.status == "waiting") {
        // loading succeeded, game is waiting for players.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameStartPage(
              numberOfPlayers: numberOfPlayers,
              playerNames: const ['susan'],
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
      Song('Unicorn', 'Noa Kirel', '358936', 'assets/images/background.png', "unicorn", 2),
      Song('Flowers', 'Miley Cirus', '495863', 'assets/images/background.png', "flowers", 3),
      Song('Starships', 'Nicky Minaj', '43609376', 'assets/images/background.png', "starships", 4),
      Song('Test App', 'Just Dance Team', '----', 'assets/images/background.png', "test_app_dance", 1),
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

          Padding(
            padding: const EdgeInsets.only(left: 350.0, right: 20.0),
            // Adjusted padding
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
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    return SongCard(
                      title: songs[itemIndex].title,
                      artist: songs[itemIndex].artist,
                      bestScore: songs[itemIndex].bestScore,
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
                      // TODO: add sound effect :)
                    },
                    scrollDirection:
                        Axis.vertical,
                  ),
                )),
          ),

          // Just Dance logo on the top left corner
          Positioned(
              left: (350 - 150 - 50) / 2,
              // SongCard's margin from left, logo's width.
              top: (350 - 150 - 60) / 2,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/jd-logo.png',
                    width: 150,
                  ),
                  const SizedBox( height: 30,),
                  SettingWidget(
                    numberOfPlayers: numberOfPlayers,
                    onNumberOfPlayersChanged: _onNumberOfPlayersChanged,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
