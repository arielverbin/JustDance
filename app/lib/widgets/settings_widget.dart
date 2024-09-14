import 'package:app/widgets/character_pick_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/adjust_angle_page.dart';
import 'package:app/widgets/about_just_dance.dart';
import 'camera_widget.dart';

class SettingWidget extends StatefulWidget {
  final Function(List<String>) updatePlayerSelections; // Add the callback
  final Function(double) updateCameraAngle;

  const SettingWidget({
    super.key,
    required this.updatePlayerSelections, // Initialize in constructor
    required this.updateCameraAngle,
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
            updatePlayerSelections:
            widget.updatePlayerSelections, // Forward the callback
          ),
          const SizedBox(height: 16),
          const CameraWidget(),
          const SizedBox(height: 16),
          AdjustAngleWidget(
            updateCameraAngle: widget.updateCameraAngle,
          ),
          const SizedBox(height: 26),
          const AboutJustDance(),
        ],
    );
  }
}