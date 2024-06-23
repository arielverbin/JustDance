import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:app/widgets/feedback_widget.dart';
import 'package:path/path.dart';


class GameStartPage extends StatelessWidget {
  const GameStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1215),
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ), const SizedBox(height: 20,),
                  const Text(
                    "Stay In Frame!",
                    style: TextStyle(
                      fontSize: 30.0,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Text(
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
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
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
                    "Please keep your hands raised. The game will start when\nenough players are raising their hands.",
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
        ])
      ]),
    );
  }
}
