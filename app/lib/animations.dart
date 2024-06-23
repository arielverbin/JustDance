import 'dart:math';
import 'package:app/pages/game_start.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:app/widgets/feedback_widget.dart';

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
  _AnimationsTestingState createState() => _AnimationsTestingState();
}

class _AnimationsTestingState extends State<AnimationTesting> {
  String _displayText = '';
  Color _textColor = Colors.black;
  int _uniqueKey = 0;

  void _startAnimation(String text, Color color) {
    setState(() {
      _displayText = text;
      _textColor = color;
      _uniqueKey++; // Increment the unique key to force rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1215),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_displayText.isNotEmpty)
            FeedbackWidget(
              key: ValueKey(_uniqueKey), // Use the unique key
              text: _displayText,
              color: _textColor,
            ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _startAnimation('PERFECT', Colors.cyanAccent),
                child: const Text('Perfect'),
              ),
              ElevatedButton(
                onPressed: () => _startAnimation('GOOD', Colors.indigoAccent),
                child: const Text('Good'),
              ),
              ElevatedButton(
                onPressed: () => _startAnimation('OK', Colors.lightGreenAccent),
                child: const Text('OK'),
              ),
              ElevatedButton(
                onPressed: () => _startAnimation('NAH', Colors.orange),
                child: const Text('Nah'),
              ),
              ElevatedButton(
                onPressed: () => _startAnimation('X', Colors.redAccent),
                child: const Text('X'),
              ),
            ],
          ),

          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GameStartPage()));
              },
              child: const Text('Game Start'))
        ],
      )),
    );
  }
}
