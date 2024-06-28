import 'package:app/pages/in_game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;

class GameStartPage extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;
  final String songTitle;

  const GameStartPage({super.key, required this.numberOfPlayers, required this.songTitle, required this.playerNames});

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
    await Future.delayed(const Duration(seconds: 5));
    if(mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InGamePage(songTitle: widget.songTitle,
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
      body: Stack(children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          /** First Instruction **/
          IntrinsicWidth(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 50),
              flutter.Image.asset(
                'assets/images/stay-in-frame.gif',
                height: 100,
              ),
              const SizedBox(width: 25),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stay In Frame!",
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
              const SizedBox(width: 55),
            ],
          )),


          /** Second Instruction**/
          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          IntrinsicWidth(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              flutter.Image.asset(
                'assets/images/raise-hands.gif',
                height: 100,
              ),
              const SizedBox(width: 5),
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

                  Text(
                    widget.numberOfPlayers == 1 ? "Please keep your hands raised. The game will start when\nsomeone is raising their hands." :
                    "Please keep your hands raised. The game will start when\ntwo players are raising their hands.",
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                    ),
                  )
                ],
              ),
              const SizedBox(width: 55),
            ],
          )),
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
      ]),
    );
  }
}
