import 'dart:async';
import 'package:app/pages/in_game_page.dart';
import 'package:app/utils/service/client.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'dart:math';

import '../widgets/gradient_text.dart';
import 'package:app/utils/service/service.pbgrpc.dart';

class GameStartPage extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;
  final String songName;

  final String Function(String, String, int) updateAndSaveNewScores;

  const GameStartPage({
    super.key,
    required this.numberOfPlayers,
    required this.songName,
    required this.playerNames,
    required this.updateAndSaveNewScores
  });

  @override
  GameStartState createState() => GameStartState();
}

class GameStartState extends State<GameStartPage> {
  late int playersLeft = 3;
  bool _isPolling = true;
  bool canceling = false;
  late List<String> tips = [
    "Make sure that throughout the game all players are fully visible for the camera.",
    "Optimize your camera setup with good lighting and a clear background.",
    "Throughout the game, stand in front of the camera and face it directly.",
    "Switching places with other players might confuse the scoring mechanism."
  ];

  int _currentTipIndex = 0;
  double _opacity = 1.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    playersLeft = 3;
    tips.shuffle(Random());

    _waitForGameStart();

    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      setState(() {
        _opacity = 0.0;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _currentTipIndex = (_currentTipIndex + 1) % tips.length;
            _opacity = 1.0;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _isPolling = false;
    super.dispose();
  }

  void _waitForGameStart() async {
    final client = ScoringPoseServiceClient(getClientChannel());
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setVolume(0.6);

    while (_isPolling) {
      try {
        final response = await client.startGame(EmptyMessage(status: ""));

        if (mounted) {

          int newPlayersLeft =  widget.numberOfPlayers - response.numberOfPlayers;
          int oldPlayersLeft = playersLeft;

          setState(() {
            // TODO: too many are raising their hands!
            playersLeft = newPlayersLeft;
          });

          if(newPlayersLeft > 0) {
            if (newPlayersLeft > oldPlayersLeft) {
              audioPlayer.play(
                  AssetSource('sound-effects/players-decrease.mp3'));
            } else if (newPlayersLeft < oldPlayersLeft) {
              audioPlayer.play(
                  AssetSource('sound-effects/players-increase.mp3'));
            }
          }

          if (response.status == "ready") {

            audioPlayer.play(AssetSource('sound-effects/game-on.mp3'));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InGamePage(
                  songName: widget.songName,
                  numberOfPlayers: widget.numberOfPlayers,
                  playerNames: widget.playerNames,
                  updateAndSaveNewScores: widget.updateAndSaveNewScores,
                ),
              ),
            );
            break; // Exit the loop
          }
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _cancelGame() async {
    _isPolling = false;
    if (canceling) return;

    setState(() {
      canceling = true;
    });

    ScoringPoseServiceClient(getClientChannel())
        .startGame(EmptyMessage(status: 'cancel'))
        .then((response) {
      if (response.status == "canceled") {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1215),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              flutter.Image.asset(
                'assets/images/raise-hands.gif',
                height: 220,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ready? Raise Your Hands!",
                    style: TextStyle(
                      fontSize: 30.0,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Keep your hands raised. The game will start when",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  playersLeft < 3 ? (
                    GradientText(
                      playersLeft == 0
                          ? "STARTING..."
                          : (playersLeft == 1
                          ? "1 MORE PLAYER"
                          : (playersLeft < 0
                          ? "TOO MANY PLAYERS"
                          : "$playersLeft MORE PLAYERS")),
                      style: const TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff6793e1),
                          Color(0xff7564e1),
                          Color(0xffC65BCF),
                          Color(0xffF27BBD),
                        ],
                      ),
                    )
                  ) : (
                    const Text("HOLD ON...", style: TextStyle(
                      fontSize: 50.0,
                      color: Colors.white24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),) ),
                  Text(
                    playersLeft == 1
                        ? " is raising their hands."
                        : (playersLeft == 2 ? " are raising their hands." : ""),
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 50,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    tips[_currentTipIndex],
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white54,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _cancelGame();
                },
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      canceling ? "Canceling..." : "Back to Song List",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
