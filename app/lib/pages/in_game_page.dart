import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:app/widgets/score_widget.dart';
import 'package:app/pages/winner_page.dart';

class InGamePage extends StatefulWidget {
  final String songTitle;
  final int numberOfPlayers;
  final List<String> playerNames;

  const InGamePage({
    super.key,
    required this.songTitle,
    required this.numberOfPlayers,
    required this.playerNames,
  });

  @override
  InGamePageState createState() => InGamePageState();
}

class InGamePageState extends State<InGamePage> {
  late VideoPlayerController _controller;
  late List<int> scores;
  late List<int> totalScores;
  late List<GlobalKey<ScoreWidgetState>> scoreWidgetKeys;
  late bool _inGame = true;

  @override
  void initState() {
    super.initState();
    scores = [0, 0];
    totalScores = List<int>.filled(widget.numberOfPlayers, 0);
    scoreWidgetKeys = List<GlobalKey<ScoreWidgetState>>.generate(
        widget.numberOfPlayers, (_) => GlobalKey<ScoreWidgetState>());

    // Initialize the controller with a local asset video file
    _controller =
        VideoPlayerController.asset('assets/songs/${widget.songTitle}.mov')
          ..addListener(() {
            setState(() {});
            _checkVideoEnd();
          })
          ..setLooping(false)
          ..initialize().then((_) => setState(() {}));
    _controller.play();

    // Start the timer to update scores
    _maintainScore();
  }

  // Asynchronous function to simulate getting scores for the players
  Future<(List<int>, List<int>)> _getScore() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate a delay
    Random random = Random();
    var score1 = random.nextInt(100);
    var score2 = random.nextInt(100);
    var totalScore1 = random.nextInt(100);
    var totalScore2 = random.nextInt(100);
    return (
      [score1, score2],
      [totalScore1, totalScore2]
    ); // Return random scores between 0 and 100
  }

  // Function to maintain the scores, updating them in a loop
  void _maintainScore() async {
    while (_inGame) {
      // Check if the widget is mounted before running the loop
      var (newScores, newTotalScores) = await _getScore(); // Get new scores
      if (_inGame) {
        // Check if the widget is mounted before calling setState
        setState(() {
          for (int i = 0; i < widget.numberOfPlayers; i++) {
            scores[i] = newScores[i];
            totalScores[i] = newTotalScores[i];
            scoreWidgetKeys[i]
                .currentState
                ?.updateScore(scores[i], totalScores[i]);
          }
        });
      }
    }
  }

  void _checkVideoEnd() {
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
        scores: totalScores,
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
