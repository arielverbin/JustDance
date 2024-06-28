import 'package:flutter/material.dart';

class SettingWidget extends StatefulWidget {
  final int numberOfPlayers;
  final ValueChanged<int> onNumberOfPlayersChanged;

  const SettingWidget({
    Key? key,
    required this.numberOfPlayers,
    required this.onNumberOfPlayersChanged,
  }) : super(key: key);

  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
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
        Text(
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
            Text(
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
            Text(
              '2',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
