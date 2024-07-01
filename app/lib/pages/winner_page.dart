import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/gradient_text.dart';

class WinnerPage extends StatefulWidget {
  final List<String> players;
  final List<int> scores;

  const WinnerPage({super.key, required this.players, required this.scores});

  @override
  WinnerPageState createState() => WinnerPageState();
}

class WinnerPageState extends State<WinnerPage> {
  bool _showReturnButton = false;
  late String winner;
  late int winnerScore;
  late String secondPlace;
  late int secondScore;

  @override
  void initState() {
    super.initState();
    _initializeWinnerAndScores();
    // Delay showing the return button after 5 seconds
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showReturnButton = true;
        });
      }
    });
  }

  void _initializeWinnerAndScores() {
    if (widget.players.length > 1 && widget.scores.length > 1) {
      if (widget.scores[1] > widget.scores[0]) {
        winner = widget.players[1];
        winnerScore = widget.scores[1];
        secondScore = widget.scores[0];
        secondPlace = widget.players[0];
      } else {
        winner = widget.players[0];
        winnerScore = widget.scores[0];
        secondScore = widget.scores[1];
        secondPlace = widget.players[1];
      }
    } else {
      winner = widget.players[0];
      winnerScore = widget.scores[0];
      secondPlace = "";
      secondScore = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/characters/$winner.svg',
                    height: 80,
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        winner.toUpperCase(),
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
                  const SizedBox(
                    width: 90,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      GradientText(
                        winnerScore.toString().padLeft(4, '0'),
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
                      ),
                      Positioned(
                        top: 20,
                        right: 0,
                        child: Transform.rotate(
                          angle: 0.2,
                          child: const Text(
                            "NEW RECORD",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black54,
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              secondPlace != "" ?
                Row(
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
                      secondPlace.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
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
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      secondScore.toString().padLeft(4, '0'),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ) : const SizedBox(),
              const SizedBox(height: 20),
            ],
          ),

          // Return button with fade-in animation
          Positioned(
            top: 20,
            left: 20,
            child: AnimatedOpacity(
              opacity: _showReturnButton ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Pop the current screen
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 10,),
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
            ),
          ),
        ],
      ),
    );
  }
}
