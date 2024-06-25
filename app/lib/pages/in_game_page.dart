import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class InGamePage extends StatefulWidget {
  final String songTitle;
  final int numberOfPlayers;
  final List<String> playerNames;

  InGamePage({
    required this.songTitle,
    required this.numberOfPlayers,
    required this.playerNames,
  });

  @override
  _InGamePageState createState() => _InGamePageState();
}

class _InGamePageState extends State<InGamePage> {
  late VideoPlayerController _controller;
  List<int> scores = [];

  @override
  void initState() {
    super.initState();
    scores = List<int>.filled(widget.numberOfPlayers, 0);
    // Initialize the controller with a local asset video file
    _controller = VideoPlayerController.asset('assets/videos/${widget.songTitle}.mov')
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(false)
      ..initialize().then((_) => setState(() {}));
    _controller.play();
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
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : const CircularProgressIndicator(),
          ),
          _buildGradientBackground(),
          if (widget.numberOfPlayers > 0)
            Positioned(
              top: 16.0,
              left: 16.0,
              child: ScoreWidget(
                playerName: widget.playerNames[0],
                score: scores[0],
                alignment: Alignment.topLeft,
              ),
            ),
          if (widget.numberOfPlayers > 1)
            Positioned(
              top: 16.0,
              right: 16.0,
              child: ScoreWidget(
                playerName: widget.playerNames[1],
                score: scores[1],
                alignment: Alignment.topRight,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      height: 100.0, // Adjust the height based on your ScoreWidget's height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class ScoreWidget extends StatelessWidget {
  final String playerName;
  final int score;
  final Alignment alignment;

  const ScoreWidget({
    required this.playerName,
    required this.score,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: alignment == Alignment.topLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            playerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Score: $score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
