import 'package:flutter/material.dart';

class AboutJustDance extends StatelessWidget {
  const AboutJustDance({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins',
      color: Colors.white,
      fontSize: 18,
    );

    TextStyle bodyStyle = const TextStyle(
      fontWeight: FontWeight.w300,
      fontFamily: 'Poppins',
      color: Color.fromRGBO(255, 255, 255, 0.7),
      fontSize: 16,
    );

    return SizedBox(
        width: 236,
        child: Column(
          children: [
            Text('ABOUT JUST DANCE', // Second part with a different style
                style: titleStyle),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Just Dance is a motion-based dance game.",
              style: bodyStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Your goal is to match the on-screen moves and earn points based on your accuracy and timing.",
              style: bodyStyle,
              textAlign: TextAlign.center,
            ),

          ],
        ));
  }
}