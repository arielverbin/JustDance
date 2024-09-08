import 'package:app/widgets/graph_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../pages/winner_page.dart';

class SettingWidget extends StatefulWidget {
  final int numberOfPlayers;
  final ValueChanged<int> onNumberOfPlayersChanged;

  const SettingWidget({
    super.key,
    required this.numberOfPlayers,
    required this.onNumberOfPlayersChanged,
  });

  @override
  SettingWidgetState createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {
  late int _selectedNumberOfPlayers;

  @override
  void initState() {
    super.initState();
    _selectedNumberOfPlayers = widget.numberOfPlayers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'NUMBER OF PLAYERS',
          style: TextStyle(color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<int>(
              value: 1,
              groupValue: _selectedNumberOfPlayers,
              onChanged: (value) {
                setState(() {
                  _selectedNumberOfPlayers = value!;
                  widget.onNumberOfPlayersChanged(_selectedNumberOfPlayers);
                });
              },
            ),
            const Text(
              '1',
              style: TextStyle(color: Colors.white),
            ),
            Radio<int>(
              value: 2,
              groupValue: _selectedNumberOfPlayers,
              onChanged: (value) {
                setState(() {
                  _selectedNumberOfPlayers = value!;
                  widget.onNumberOfPlayersChanged(_selectedNumberOfPlayers);
                });
              },
            ),
            const Text(
              '2',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),

        // Example usage
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WinnerPage(players: ["susan", "noah"],
                    plotScoresPlayer1: [FlSpot(0, 20), FlSpot(10, 10), FlSpot(20, 30), FlSpot(30, 40), FlSpot(40, 70), FlSpot(50, 100), FlSpot(60, 100), FlSpot(70, 60), FlSpot(80, 10)],
                  plotScoresPlayer2: [FlSpot(0, 60), FlSpot(10, 50), FlSpot(20, 40), FlSpot(30, 10), FlSpot(40, 80), FlSpot(50, 100), FlSpot(60, 30), FlSpot(70, 10), FlSpot(80, 30)],
                  //plotScoresPlayer2: [],
                ),
              ),
            );
          },
        )


      ],
    );
  }
}
