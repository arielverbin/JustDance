import 'dart:async';
import 'package:app/widgets/graph_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/service/client.dart';
import '../utils/service/service.pbgrpc.dart';
import '../widgets/alert_widget.dart';
import '../widgets/gradient_text.dart';

class WinnerPage extends StatefulWidget {
  final List<String> players;
  final List<FlSpot> plotScoresPlayer1;
  final List<FlSpot> plotScoresPlayer2;

  final String songName;
  final String Function(String, String, int) updateAndSaveNewScore;

  const WinnerPage(
      {super.key,
      required this.players,
      required this.plotScoresPlayer1,
      required this.plotScoresPlayer2,
      required this.songName,
      required this.updateAndSaveNewScore});

  @override
  WinnerPageState createState() => WinnerPageState();
}

class WinnerPageState extends State<WinnerPage> with SingleTickerProviderStateMixin {
  bool _showReturnButton = false;
  bool _showWinnerText = false;
  bool _showWinnerRow = false;
  bool _showSecondRow = false;
  bool _showGraph = false;

  String? winnerName;
  int? winner;
  int? winnerScore;
  String? secondPlace;
  int? secondScore;

  late Future<void> _winnerFuture;
  final ValueNotifier<int> _scoreNotifier = ValueNotifier<int>(0);

  late ConfettiController _confettiController; // Woo ho!

  late AnimationController _newRecordController;
  late Animation<double> _newRecordAnimation;
  String recordText = "";

  @override
  void initState() {
    super.initState();
    _winnerFuture = _initializeWinnerAndScores();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));

    _newRecordController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);

    _newRecordAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _newRecordController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _newRecordController.dispose();
    super.dispose();
  }

  Future<void> _initializeWinnerAndScores() async {
    try {
      final client = ScoringPoseServiceClient(getClientChannel());
      EndStatus status = await client.endGame(EndRequest());
      winner = status.winner;

      if (widget.players.length > 1) {
        if (winner == 0) {
          winnerName = widget.players[0];
          winnerScore = status.totalScore1;
          secondPlace = widget.players[1];
          secondScore = status.totalScore2;
        } else {
          winnerName = widget.players[1];
          winnerScore = status.totalScore2;
          secondPlace = widget.players[0];
          secondScore = status.totalScore1;
        }
      } else {
        winnerName = widget.players[0];
        winnerScore = status.totalScore1;
        secondPlace = "";
        secondScore = 0;
      }

      // Update homepage and save scores to local storage.
      setState(() {
        recordText = widget.updateAndSaveNewScore(widget.songName, winnerName!, winnerScore!);
      });
      // Will not show 'new record' for the second place.
      widget.updateAndSaveNewScore(widget.songName, secondPlace!, secondScore!);

    } catch (err) {
      // Gently handle errors.
      if(mounted) {
        AlertWidget.showError(context,
          AlertWidget(
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40.0),
            color: Colors.grey.shade800,
            title: "Error Loading Scores",
            content: err.toString(),
            duration: 2,
          ),
        );
      }
    }


    // Start the sequence of animations
    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    int delay = 0;

    // Delay the "And the winner is..." fade-in to create a smooth effect
    if (widget.players.length > 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _showWinnerText = true; // Fade in
        });
      });
    }

    if (widget.players.length > 1) {
      delay = 3000;

      // Fade out "And the winner is..." text after 3 seconds
      Future.delayed(Duration(milliseconds: delay), () {
        setState(() {
          _showWinnerText = false; // Fade out
        });
      });
    }

    Future.delayed(Duration(seconds: 2, milliseconds: delay), () {

      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.setVolume(0.6);
      audioPlayer.play(AssetSource('sound-effects/winning'
          '${widget.players.length > 1 ? "" : "-singleplayer"}.mp3'));

      setState(() {
        _showWinnerRow = true;
        _showGraph = true;

        if(widget.players.length > 1) {
          _confettiController.play();
        }

      });

      // Animate the score
      _scoreNotifier.value = 0;
      Future.delayed(const Duration(milliseconds: 100), () {
        _animateScore();
      });
    });

    if (widget.players.length > 1) {
      delay += 2000;
      Future.delayed(const Duration(seconds: 8), () {
        setState(() {
          _showSecondRow = true;
        });
      });
    }

    Future.delayed(Duration(seconds: 4, milliseconds: delay), () {
      setState(() {
        _showReturnButton = true;
      });
    });
  }


  void _animateScore() {
    int duration = 1000; // Duration of the animation in milliseconds
    int steps = 50; // Number of steps in the animation
    int stepDuration = duration ~/ steps;
    int stepIncrement = (winnerScore ?? 0) ~/ steps;

    // Define a threshold below which the animation is skipped
    const int minScoreForAnimation = 100;

    if ((winnerScore ?? 0) < minScoreForAnimation) {
      // If the score is too low, just set the final value without animation
      _scoreNotifier.value = winnerScore ?? 0;
      return;
    }

    Timer.periodic(Duration(milliseconds: stepDuration), (Timer timer) {
      if (_scoreNotifier.value >= (winnerScore ?? 0)) {
        timer.cancel();
      } else {
        _scoreNotifier.value =
            (_scoreNotifier.value + stepIncrement).clamp(0, winnerScore ?? 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      Stack(
        fit: StackFit.expand,
        children: [
        Opacity(
        opacity: 0.3,
        child: Image.asset(
          "assets/images/background.png",
          fit: BoxFit.cover,
        ),
      ),
      FutureBuilder(
        future: _winnerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            return _buildErrorScreen();
          } else {
            return _buildWinnerPageContent(context);
          }
        },
      )]),
    );
  }

  Widget _buildErrorScreen() {
    return Stack(
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text(
            "Error loading scores.",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontFamily: 'Poppins'),
          ),
        ),
        Positioned(
          left: 20,
          top: 20,
          child: _buildReturnButton(context, false),
        ),
      ],
    );
  }

  Widget _buildReturnButton(context, bool animate) {
    return AnimatedOpacity(
      opacity: animate ? (_showReturnButton ? 1.0 : 0.0) : 1.0,
      duration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Row(
          children: [
            Icon(Icons.arrow_back, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Back to Song List",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerPageContent(context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            // Winner row
            AnimatedOpacity(
              opacity: _showWinnerRow ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/characters/$winnerName.svg',
                    height: 80,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        winnerName!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Opacity(
                        opacity: 0.6,
                        child: Text(
                          "WITH THE SCORE OF",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 90),
                  Stack(
                    children: [
                      Text(
                        "   ${winnerScore.toString().padLeft(4, '0')}",
                        style: const TextStyle(
                          fontSize: 99,
                          color: Color.fromRGBO(0, 0, 0, 0),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: _scoreNotifier,
                        builder: (context, score, child) {
                          return GradientText(
                            score.toString().padLeft(4, '0'),
                            style: const TextStyle(
                              fontSize: 99,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff6793e1),
                                Color(0xff7564e1),
                                Color(0xffC65BCF),
                                Color(0xffF27BBD),
                              ],
                            ),
                          );
                        },
                      ),
                        Positioned(
                          right: 40, // Adjust this value to position the text beyond the right edge
                          top: 30, // Adjust the vertical positioning as needed
                          child: ScaleTransition(scale: _newRecordAnimation, child: Transform.rotate(
                            angle: 0.25,
                            child: Text(
                              recordText,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )),
                    ],
                  )

                ],
              ),
            ),

            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xff6793e1),
                Color(0xff7564e1),
                Colors.white,
                Color(0xffF27BBD),
              ],
              emissionFrequency: 0.01,
              minBlastForce: 50,
              maxBlastForce: 150,
              numberOfParticles: 50,
              gravity: 0.2,
            ),
            // Second place row
            secondPlace!.isNotEmpty
                ? AnimatedOpacity(
                    opacity: _showSecondRow ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const GradientText(
                          "#2  ",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                          gradient: LinearGradient(
                            colors: [Color(0xffC65BCF), Color(0xffF27BBD)],
                          ),
                        ),
                        Text(
                          secondPlace!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Opacity(
                          opacity: 0.6,
                          child: Text(
                            "WITH THE SCORE OF",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          secondScore!.toString().padLeft(4, '0'),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 5),
            const Spacer(),
            SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                // Centered container not taking the whole screen
                height: MediaQuery.of(context).size.height / 2,
                child: _showGraph
                    ? SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 2,
                  child: GraphWidget(
                    player1Scores: widget.plotScoresPlayer1,
                    player1Name: widget.players[0],
                    player2Scores: widget.plotScoresPlayer2,
                    player2Name: widget.players.length > 1 ? (widget.players[1]) : "none",
                    isPlayer1Winner: winner == 0,
                    chorusTimes: const [],
                  ),
                )
                    : const SizedBox()),
            const Spacer()
          ],
        ),
        Positioned(
          top: 20,
          left: 20,
          child: _buildReturnButton(context, true),
        ),
        Center(
          child: AnimatedOpacity(
            opacity: _showWinnerText ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: const Text(
              "And the winner is...",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
