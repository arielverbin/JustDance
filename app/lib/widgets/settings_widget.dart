import 'package:app/pages/winner_page.dart';
import 'package:app/widgets/character_pick_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'camera_widget.dart';

class SettingWidget extends StatefulWidget {
  final Function(List<String>) updatePlayerSelections; // Add the callback

  const SettingWidget({
    super.key,
    required this.updatePlayerSelections,  // Initialize in constructor
  });

  @override
  SettingWidgetState createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'CHARACTERS',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        CharacterPickWidget(
          updatePlayerSelections: widget.updatePlayerSelections,  // Forward the callback
        ),
        const SizedBox(height: 16),
        const CameraWidget(),
        // FloatingActionButton(onPressed: () {Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const WinnerPage(
        //       players: ['caleb', 'liam'],
        //       plotScoresPlayer1: [FlSpot(0, 100), FlSpot(20, 30), FlSpot(40, 70), FlSpot(60, 0), FlSpot(80, 10), FlSpot(100, 80)],
        //       plotScoresPlayer2: [FlSpot(0, 50), FlSpot(20, 70), FlSpot(40, 20), FlSpot(60, 70), FlSpot(80, 100), FlSpot(100, 20)],
        //     )
        //   ),
        // );
        // })
      ],
    );
  }
}
