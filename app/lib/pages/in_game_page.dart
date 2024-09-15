import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:app/widgets/score_widget.dart';
import 'package:app/pages/winner_page.dart';

import '../utils/service/client.dart';
import '../utils/service/service.pbgrpc.dart';

class InGamePage extends StatefulWidget {
  final String songName;
  final int numberOfPlayers;
  final List<String> playerNames;

  final String Function(String, String, int) updateAndSaveNewScores;

  const InGamePage({
    super.key,
    required this.songName,
    required this.numberOfPlayers,
    required this.playerNames,
    required this.updateAndSaveNewScores
  });

  @override
  InGamePageState createState() => InGamePageState();
}

class InGamePageState extends State<InGamePage> {
  late VideoPlayerController _controller;
  List<int> scores = [0, 0];
  List<int> totalScores = [0, 0];
  List<FlSpot> plotScoresPlayer1 = [];
  List<FlSpot> plotScoresPlayer2 = [];
  late List<GlobalKey<ScoreWidgetState>> scoreWidgetKeys;
  final client = ScoringPoseServiceClient(getClientChannel());
  late bool _inGame = true;
  late DateTime startTime;


  @override
  void initState() {
    super.initState();
    scores = [0, 0];
    totalScores = List<int>.filled(widget.numberOfPlayers, 0);
    scoreWidgetKeys = List<GlobalKey<ScoreWidgetState>>.generate(
        widget.numberOfPlayers, (_) => GlobalKey<ScoreWidgetState>());

    // Initialize the controller with a local asset video file
    _controller =
        VideoPlayerController.asset('assets/songs/${widget.songName}.mov')
          ..addListener(() {
            setState(() {});
            _checkVideoEnd();
          })
          ..setLooping(false)
          ..initialize().then((_) => setState(() {}));
    _controller.play();
    startTime = DateTime.now();

    // Start the timer to update scores
    _maintainScore();
    _updateScoreAnimation(updateEvery: 1000);
  }

  // Asynchronous function to simulate getting scores for the players
  Future<(List<int>, List<int>)> _getScore() async {
    ScoreResponse scores = await client.getScore(TimeRequest(time: 0));
    return (
      [scores.score1, scores.score2],
      [scores.totalScore1, scores.totalScore2]
    );
  }

  // Function to maintain the scores, updating them in a loop
  void _maintainScore() async {
    double timePassed;

    while (_inGame) {
      // Check if the widget is mounted before running the loop
      var (newScores, newTotalScores) = await _getScore(); // Get new scores

      timePassed = DateTime.now().difference(startTime).inSeconds.toDouble();
      plotScoresPlayer1.add(FlSpot(timePassed, newScores[0].toDouble()));
      plotScoresPlayer2.add(FlSpot(timePassed, newScores[1].toDouble()));

      if (_inGame) {
        // Check if the widget is mounted before calling setState
        setState(() {
          for (int i = 0; i < widget.numberOfPlayers; i++) {
            scores[i] = newScores[i];
            totalScores[i] = newTotalScores[i];
            scoreWidgetKeys[i]
                .currentState
                ?.updateTotalScore(totalScores[i]);
          }
        });
      }
    }
  }

  void _updateScoreAnimation({required int updateEvery}) {
    Timer.periodic(Duration(milliseconds: updateEvery), (timer) {
      if(!_inGame) {
        timer.cancel();
        return;
      }

        setState(() {
          for (int i = 0; i < widget.numberOfPlayers; i++) {
            scoreWidgetKeys[i]
                .currentState
                ?.updateScore(scores[i]);
          }
        });
    });
  }

  void _checkVideoEnd() async {
    if (!_controller.value.isPlaying &&
        _controller.value.position == _controller.value.duration) {
      _inGame = false;
      _navigateToWinnerPage();
    }
  }

  void _navigateToWinnerPage() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => WinnerPage(
        players: widget.playerNames,
        plotScoresPlayer1: plotScoresPlayer1,
        plotScoresPlayer2: plotScoresPlayer2,
        songName: widget.songName,
        updateAndSaveNewScore: widget.updateAndSaveNewScores,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: _controller.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
          _buildGradientBackground(),
          // Displaying logo in the bottom right
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: Center(
              child: Image.asset(
                'assets/images/jd-logo.png',
                height: 100, // Adjust height as needed
              ),
            ),
          ),
          // Scores positioned widgets
          if (widget.numberOfPlayers > 0)
            Positioned(
              top: 16.0,
              left: 16.0,
              child: ScoreWidget(
                key: scoreWidgetKeys[0],
                playerIndex: 1,
                playerName: widget.playerNames[0],
                initialScore: scores[0],
                initialTotalScore: totalScores[0],
                alignment: Alignment.topLeft,
              ),
            ),
          if (widget.numberOfPlayers > 1)
            Positioned(
              top: 16.0,
              right: 16.0,
              child: ScoreWidget(
                key: scoreWidgetKeys[1],
                playerIndex: -1,
                playerName: widget.playerNames[1],
                initialScore: scores[1],
                initialTotalScore: totalScores[1],
                alignment: Alignment.topRight,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      height: 140.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.5),
            Colors.black.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
