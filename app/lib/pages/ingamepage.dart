import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:math';
import 'winnerpage.dart'; // Import the WinnerPage

class VideoPlayerScreen extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;

  // Constructor to initialize the number of players and their names
  VideoPlayerScreen({required this.numberOfPlayers, required this.playerNames});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller; // Controller to manage video playback
  List<int> scores = [0, 0]; // List to hold scores for the players (assuming 2 players for simplicity)
  bool _isMounted = true; // Flag to track if the widget is mounted
  bool _isVideoFinished = false; // Flag to track if the video has finished

  @override
  void initState() {
    super.initState();
    // Initialize the video controller with a local asset video file
    _controller = VideoPlayerController.asset('assets/songs/random.mov')
      ..addListener(() {
        if (_isMounted) {
          if (!_isVideoFinished && _controller.value.position >= _controller.value.duration) {
            _isVideoFinished = true;
            _navigateToWinnerPage(); // Navigate to WinnerPage when video ends
          }
          setState(() {}); // Update the UI when the controller's state changes
        }
      })
      ..setLooping(false) // Set the video to not loop
      ..initialize().then((_) {
        if (_isMounted) {
          setState(() {}); // Initialize the controller and update the UI
          _controller.play(); // Start playing the video after initialization
        }
      });
    maintainScore(); // Start the score maintenance loop
  }

  @override
  void dispose() {
    _isMounted = false; // Set the flag to false
    _controller.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  // Asynchronous function to simulate getting scores for the players
  Future<List<int>> get_score() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate a delay
    Random random = Random();
    return [random.nextInt(100), random.nextInt(100)]; // Return random scores between 0 and 100
  }

  // Function to maintain the scores, updating them in a loop
  void maintainScore() async {
    while (_isMounted) { // Check if the widget is mounted before running the loop
      List<int> newScores = await get_score(); // Get new scores
      if (_isMounted) { // Check if the widget is mounted before calling setState
        setState(() {
          scores = newScores; // Update the scores
        });
      }
    }
  }

  // Function to navigate to WinnerPage
  void _navigateToWinnerPage() {
    if (_isMounted) { // Check if the widget is still mounted before navigating
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WinnerPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized // Check if the video controller is initialized
            ? Stack(
          alignment: Alignment.topCenter,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio, // Maintain the video's aspect ratio
              child: VideoPlayer(_controller), // Display the video
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(widget.numberOfPlayers, (index) {
                  return Text(
                    '${widget.playerNames[index]}: ${scores[index]}', // Display player name and score
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
            ),
          ],
        )
            : const CircularProgressIndicator(), // Show a loading indicator while the video is initializing
      ),
    );
  }
}
