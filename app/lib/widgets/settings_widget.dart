import 'package:app/widgets/character_pick_widget.dart';
import 'package:app/widgets/clear_storage.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/adjust_angle_page.dart';
import 'package:app/widgets/about_just_dance.dart';
import 'camera_widget.dart';

class SettingWidget extends StatefulWidget {
  final Function(List<String>) updatePlayerSelections;
  final Function(double) updateCameraAngle;
  final Function() clearAllScores;

  const SettingWidget({
    super.key,
    required this.updatePlayerSelections,
    required this.updateCameraAngle,
    required this.clearAllScores,
  });

  @override
  SettingWidgetState createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height - 250,
      child: SingleChildScrollView(
        child: Column(
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
              updatePlayerSelections: widget.updatePlayerSelections,
            ),
            const SizedBox(height: 16),
            const CameraWidget(),
            const SizedBox(height: 16),
            AdjustAngleWidget(
              updateCameraAngle: widget.updateCameraAngle,
            ),
            const SizedBox(height: 26),
            const AboutJustDance(),
            const SizedBox(height: 26),
            ClearStorageWidget(clearAllScores: widget.clearAllScores),
          ],
        ),
      ),
    );
  }
}
