import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  late RTCVideoRenderer _renderer;
  MediaStream? _localStream;
  bool _isReleasingCamera = false; // Track if the camera is being released
  late List<String> tips = [
    "Make sure that throughout the game all players are fully visible for the camera.",
    "Optimize your camera setup with good lighting and a clear background.",
    "Throughout the game, stand in front of the camera and face it directly.",
    "Switching places with other players might confuse the scoring mechanism."
  ];
  int _currentTipIndex = 0;
  double _opacity = 1.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _renderer = RTCVideoRenderer();
    _initializeCamera();

    tips.shuffle(Random());

    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      setState(() {
        _opacity = 0.0;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _currentTipIndex = (_currentTipIndex + 1) % tips.length;
            _opacity = 1.0;
          });
        }
      });
    });
  }

  Future<void> _initializeCamera() async {
    await _renderer.initialize();

    try {
      _localStream = await navigator.mediaDevices.getUserMedia({
        'video': true,
        'audio': false, // No audio stream needed for preview
      });
      _renderer.srcObject = _localStream;
      setState(() {}); // Notify the UI that the camera feed is ready
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _releaseCamera() async {
    if (_localStream != null) {
      // Stop the tracks to release the camera
      _localStream?.getTracks().forEach((track) {
        track.stop();
      });

      // Clear the renderer's stream
      _renderer.srcObject = null;

      // Dispose of local stream and renderer
      await _localStream?.dispose();
      await _renderer.dispose();

      // Add a small delay to ensure the camera is fully released
      await Future.delayed(const Duration(seconds: 1));

      // Mark the camera as released
      setState(() {
        _isReleasingCamera = false;
      });
    }
  }

  @override
  void dispose() {
    _localStream?.dispose();
    _renderer.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Camera preview with padding and rounded corners
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
            // Padding from edges
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.circular(16), // Rounded corners
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _localStream != null
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(3.14159),
                            // 180 degrees to flip horizontally
                            child: RTCVideoView(
                              _renderer,
                              objectFit: RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover, // Fits to cover the container
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
                    // Camera loading
                  ),
                ),
                const SizedBox(height: 40), // Space at the bottom
              ],
            ),
          ),

          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 50,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    tips[_currentTipIndex],
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: () async {
                if (!_isReleasingCamera) {
                  setState(() {
                    _isReleasingCamera = true;
                  });

                  // Wait until the camera is fully released
                  await _releaseCamera();

                  // Use addPostFrameCallback to ensure the context is still valid
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  });
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    _isReleasingCamera
                        ? "Releasing Camera"
                        : "Back to Song List",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key});

  void _openCameraPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CameraPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openCameraPage(context),
      child: Container(
        width: 236,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_rounded,
                color: Colors.white.withOpacity(0.5)),
            const SizedBox(width: 8),
            Text(
              'Camera Preview',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins',
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
