import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:app/pages/homepage.dart';
import 'package:app/utils/service/client.dart';
import 'package:app/utils/service/init_py.dart';
import 'package:app/utils/service/service.pbgrpc.dart';
import 'package:app/animations.dart';

import 'package:flutter/material.dart';

Future<void> initService = Future(() => null);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initService = initPy();

  runApp(const MainApp());  // Change back to MainApp!
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InitPage(),
    );
  }
}

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  InitPageState createState() => InitPageState();
}

class InitPageState extends State<InitPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  var _loadText = "Loading...";
  Future<loadStatus> _loadStatus = Future(() => loadStatus());

  @override
  /// Initializes the animation controllers,
  /// starts the animation and loads the services. *
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    startAnimation();
    loadService();
  }

  /// Establish the connection to the python service, loads learning model to memory.
  /// Navigates to HomePage if loading was successful. *
  Future<void> loadService() async {
    try {
      await initService; // wait for server to start.
      _loadStatus = ScoringPoseServiceClient(getClientChannel()).loadService(loadData());
      if ((await _loadStatus).status == 'success') {
        navigateToHomePageIfReady();
      } else {log((await _loadStatus).status);}

    } catch (error) { // If initService fails.
      log(error.toString());
    }
  }

  /// Navigates to home page. *
  void navigateToHomePageIfReady() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage())
    );
  }

  /// Animates the loading bar and displays informative load status. *
  Future<void> startAnimation() async {
    try {
      setState(() {_loadText = "Loading...";});

      await Future.any([
        _controller.animateTo(0.5, duration: const Duration(seconds: 10)),
        initService,
      ]);

      if (_controller.value < 0.5) {
        await _controller.animateTo(0.5, duration: const Duration(seconds: 1));
      }
      await initService; // In-case initService took more than 10 seconds.
      setState(() {_loadText = "Initializing model...";});

      await _controller.animateTo(1.0, duration: const Duration(seconds: 10));
      if ((await _loadStatus).status != 'success') {
        _controller.animateTo(0.0, duration: const Duration(seconds: 1));
        setState(() {
          _loadText = "An error occurred while initializing model. Try re-opening the app.";
        });
      }
    } catch(error) {
      _controller.animateTo(0.0, duration: const Duration(seconds: 1));
      setState(() {_loadText = "An error occurred. Try re-opening the app.";});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1215),
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1), // 10% of window's width
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Logo. *
              flutter.Image.asset(
                'assets/images/jd-logo.png',
                width: MediaQuery.of(context).size.width * 0.15,
              ),

              /// Progress-bar. *
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _animation.value,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                },
              ),

              /// Loading-status. *
              const SizedBox(height: 10),
              Text(_loadText, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
