import 'package:app/app_storage.dart';
import 'package:flutter/material.dart';

class AdjustCameraAnglePage extends StatefulWidget {
  final Function(double) updateCameraAngleAndText;
  final double startingCameraAngle;

  const AdjustCameraAnglePage({super.key, required this.updateCameraAngleAndText, required this.startingCameraAngle});

  @override
  AdjustCameraAnglePageState createState() => AdjustCameraAnglePageState();
}

class AdjustCameraAnglePageState extends State<AdjustCameraAnglePage> {
  late double _cameraPosition;
  late double _scaledPosition;
  double _startPosition = 0.0;

  late bool changedAngle = false;

  List<String> clarifications = [
    "Your camera is on the ground.",
    "Your camera is positioned below you.",
    "Your camera is roughly at chest level.",
    "Your camera is positioned above you."
  ];
  late int clarifyIndex;

  static int getClarifyIndex(double angle) {
    if (angle == 0) {
      return 0;
    } else if (angle < 0.45) {
      return 1;
    } else if (angle < 0.7) {
      return 2;
    } else {
      return 3;
    }
  }

  @override
  void initState() {
    super.initState();
    _scaledPosition = widget.startingCameraAngle;
    _cameraPosition = widget.startingCameraAngle * (700 - 15);

    clarifyIndex = getClarifyIndex(_scaledPosition);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1215),
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Adjust Camera Angle",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Colors.white)),
            const SizedBox(
              height: 10,
            ),
            Text(
                "Drag the dot along the line below to "
                "match the camera angle with yours.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    color: Colors.white.withOpacity(0.7))),
            Text(
                "This helps improve scoring accuracy by aligning the game’s "
                "view with your perspective.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    color: Colors.white.withOpacity(0.7))),
            const SizedBox(
              height: 70,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Transform.translate(
                  offset: const Offset(-150, 0),
                  child: Stack(alignment: Alignment.center, children: [
                    Image.asset(
                      'assets/images/person.png',
                      height: 240, // Person height
                    ),
                    Transform.translate(
                      offset: Offset(80,
                          -30 * _scaledPosition + 50 * (1 - _scaledPosition)),
                      child: Transform.rotate(
                        angle: -0.33 * _scaledPosition +
                            0.33 * (1 - _scaledPosition),
                        child: Image.asset(
                          'assets/images/camera.png',
                          height: 340,
                        ),
                      ),
                    ),
                  ])),
            ]),
            const SizedBox(
              height: 50,
            ),
            Text(clarifications[clarifyIndex],
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.5))),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                // Dashed line
                SizedBox(
                  height: 50,
                  width: 700,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          50, // Number of dashes
                          (index) => Container(
                            width: 6,
                            height: 2,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Draggable camera icon
                Positioned(
                  left: _cameraPosition,
                  // Bind the icon to the camera position
                  child: MouseRegion(
                      cursor: SystemMouseCursors.grabbing,
                      child: GestureDetector(
                        onPanStart: (details) {
                          // Track the initial position of the dot
                          _startPosition = _cameraPosition;
                          changedAngle = true;
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            // Calculate the new position
                            double newPosition =
                                _startPosition + details.localPosition.dx;
                            // Constrain the camera movement within the line
                            if (newPosition < 0) {
                              newPosition = 0;
                            } else if (newPosition > 700 - 15) {
                              // Keep the camera icon within bounds
                              newPosition = 700 - 15;
                            }
                            _cameraPosition = newPosition;
                            _scaledPosition = _cameraPosition / (700 - 15);

                            clarifyIndex = getClarifyIndex(_scaledPosition);

                          });
                        },
                        onPanEnd: (details) {
                          widget.updateCameraAngleAndText(_scaledPosition);
                        },
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )),
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
                  Navigator.pop(context); // Pop the current screen
                },
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${changedAngle ? "Save & " : ""}Back to Song List",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ]),
    );
  }
}

class AdjustAngleWidget extends StatefulWidget {
  final Function(double) updateCameraAngle;

  const AdjustAngleWidget({
    super.key,
    required this.updateCameraAngle,
  });

  @override
  AdjustAngleWidgetState createState() => AdjustAngleWidgetState();
}

class AdjustAngleWidgetState extends State<AdjustAngleWidget> {
  late double cameraAngle = 0.5;
  late int clarifyIndex = 2;

  final AppStorage appStorage = AppStorage();
  final List<String> clarifications = const [
    "Your camera is on the ground.",
    "Your camera is positioned below you.",
    "Your camera is roughly at chest level.",
    "Your camera is positioned above you."
  ];


  @override
  void initState(){
    super.initState();
    loadCameraAngle();
  }

  Future<void> loadCameraAngle() async {
    final loadedAngle = await appStorage.loadCameraAngle();

    updateCameraAngleAndText(loadedAngle);
  }

  void _openAdjustAnglePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdjustCameraAnglePage(
            updateCameraAngleAndText: updateCameraAngleAndText,
            startingCameraAngle: cameraAngle
        ),
      ),
    );
  }


  void updateCameraAngleAndText(double newAngle) {
    widget.updateCameraAngle(newAngle);
    int newIndex = AdjustCameraAnglePageState.getClarifyIndex(newAngle);

    appStorage.saveCameraAngle(newAngle);

    setState(() {
      cameraAngle = newAngle;
      clarifyIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openAdjustAnglePage(context),
      child: Container(
        width: 236,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                clarifications[clarifyIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Poppins',
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Adjust Camera Angle',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
