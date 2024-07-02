import 'package:app/pages/in_game_page.dart';
import 'package:app/utils/service/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:grpc/grpc.dart';
import '../widgets/gradient_text.dart';
import 'package:app/utils/service/service.pbgrpc.dart';


class GameStartPage extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;
  final String songTitle;

  const GameStartPage({
    super.key,
    required this.numberOfPlayers,
    required this.songTitle,
    required this.playerNames,
  });

  @override
  GameStartState createState() => GameStartState();
}

class GameStartState extends State<GameStartPage> {
  late int playersLeft = 2;
  bool _isPolling = true;
  bool canceling = false;

  @override
  void initState() {
    super.initState();
    playersLeft = widget.numberOfPlayers;
    _waitForGameStart();
  }

  void _waitForGameStart() async {
    final client = ScoringPoseServiceClient(getClientChannel());

    while (_isPolling) {
      try {
        final response = await client.startGame(EmptyMessage(status: ""));
        if(mounted){
          setState(() {
            playersLeft = widget.numberOfPlayers - response.numberOfPlayers;
          });

          if (response.status == "ready") {
            // if (mounted) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => InGamePage(
            //         songTitle: widget.songTitle,
            //         numberOfPlayers: widget.numberOfPlayers,
            //         playerNames: widget.playerNames,
            //       ),
            //     ),
            //   );
            // }
            // break; // Exit the loop
        }
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _cancelGame() async {
    _isPolling = false;
    if(canceling) return;

    setState(() { canceling = true; });

    ScoringPoseServiceClient(getClientChannel())
        .startGame(EmptyMessage(status: 'cancel'))
        .then((response) {

          if(response.status == "canceled") {
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
    });

  }

  @override
  void dispose() {
    _isPolling = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1215),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /** First Instruction **/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      flutter.Image.asset(
                        'assets/images/stay-in-frame.gif',
                        height: 100,
                      ),
                      const SizedBox(width: 3),
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
                          ),
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
                          ),
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
                              const Text("Please keep your hands raised. The game will start when",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Row(
                                children: [
                                  GradientText(
                                    playersLeft == 0
                                        ? "STARTING..."
                                        : "$playersLeft MORE PLAYERS",
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
                                    playersLeft == 1
                                        ? " is raising their hands."
                                      : (playersLeft == 2 ? " are raising their hands." : ""),
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
              onTap: () {
                _cancelGame();
              },
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    canceling ? "Canceling..." :
                    "Back to Song List",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
