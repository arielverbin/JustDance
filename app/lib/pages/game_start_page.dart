import 'package:app/pages/in_game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;

import '../widgets/gradient_text.dart';

class GameStartPage extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;
  final String songTitle;

  const GameStartPage(
      {super.key,
      required this.numberOfPlayers,
      required this.songTitle,
      required this.playerNames});

  @override
  GameStartState createState() => GameStartState();
}

class GameStartState extends State<GameStartPage> {
  @override
  void initState() {
    super.initState();
    _waitForGameStart();
  }

  void _waitForGameStart() async {
    await Future.delayed(const Duration(seconds: 50));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InGamePage(
              songTitle: widget.songTitle,
              numberOfPlayers: widget.numberOfPlayers,
              playerNames: widget.playerNames),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1215),
      body: Stack(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly
              ,crossAxisAlignment: CrossAxisAlignment.start, children: [
            /** First Instruction **/
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    flutter.Image.asset(
                      'assets/images/stay-in-frame.gif',
                      height: 100,
                    ),
                    const SizedBox(width: 3,),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stay In Frame",
                          style: TextStyle(
                            fontSize: 30.0,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          "For accurate scoring, make sure that throughout the game\nall players are fully visible for the camera.",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Poppins',
                          ),
                        )
                      ],
                    ),
                  ],
                ),

            /** Second Instruction**/
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                flutter.Image.asset(
                  'assets/images/raise-hands.gif',
                  height: 100,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Perfect Your Dance Space",
                      style: TextStyle(
                        fontSize: 30.0,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      "For best capture, optimize your camera setup with good\nlighting and a clear background.",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins',
                      ),
                    )
                  ],
                ),
              ],
            ),

            /** Third Instruction**/
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                flutter.Image.asset(
                  'assets/images/raise-hands.gif',
                  height: 100,
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
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.numberOfPlayers == 1 ?
                            "Please keep your hands raised. The game will start when" : "Please keep your hands raised.",
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Row(children: [
                            GradientText(
                              widget.numberOfPlayers == 1
                                  ? "1 MORE PLAYER"
                                  : "STARTING...",
                              style: const TextStyle(
                                fontSize: 20.0,
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
                            ),
                            Text(
                              widget.numberOfPlayers == 1
                                  ? " is raising their hands."
                                  : "",
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ]),
                        ])
                  ],
                ),
              ],
            ),
          ])
        ]),
        Positioned(
          top: 20,
          left: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Pop the current screen
            },
            child: const Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white),
                SizedBox(
                  width: 10,
                ),
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
      ]),
    );
  }
}
