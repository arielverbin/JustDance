import 'package:app/pages/game_start_page.dart';
import 'package:app/pages/winner_page.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/in_game_page.dart';

class AnimationApp extends StatelessWidget {
  const AnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnimationTesting(),
    );
  }
}

class AnimationTesting extends StatefulWidget {
  const AnimationTesting({super.key});

  @override
  AnimationsTestingState createState() => AnimationsTestingState();
}

class AnimationsTestingState extends State<AnimationTesting> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1215),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GameStartPage()));
              },
              child: const Text('Game Start')),

          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InGamePage(songTitle: "random",
                        numberOfPlayers: 2, playerNames: ["susan", "ava"],)));
              },
              child: const Text('Video Player')),

          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WinnerPage(
                          scores : const [42340,245297],
                          players: const ["susan", "liam"],)
                    ));
              },
              child: const Text('Winner Page'))
        ],
      )),
    );
  }
}
