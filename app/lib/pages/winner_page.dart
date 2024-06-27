import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/gradient_text.dart';

class WinnerPage extends StatelessWidget {
  final List<String> players;
  final List<int> scores;

  const WinnerPage({super.key, required this.players, required this.scores});

  @override
  Widget build(BuildContext context) {
    String winner = "";
    int winnerScore = 0;
    String secondPlace = "";
    int secondScore = 0;

    if (players.length > 1 && scores.length > 1) {
      if (scores[1] > scores[0]) {
        winner = players[1];
        winnerScore = scores[1];
        secondScore = scores[0];
        secondPlace = players[0];
      } else {
        winner = players[0];
        winnerScore = scores[0];
        secondScore = scores[1];
        secondPlace = players[1];
      }
    }

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
              const SizedBox(height: 50,),
              SizedBox(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    SvgPicture.asset('assets/characters/$winner.svg',
                      height: 80,),

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
                      width: 20,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        GradientText(
                          winnerScore.toString(),
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
              ),
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
                    secondScore.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
