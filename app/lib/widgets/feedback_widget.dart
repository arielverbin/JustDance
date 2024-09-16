import 'dart:async';
import 'package:flutter/material.dart';

class FeedbackWidget extends StatefulWidget {
  final String text;
  final Color color;

  const FeedbackWidget({super.key, required this.text, required this.color});

  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}

class FeedbackWidgetState extends State<FeedbackWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTimer(); // Start the timer to run the animation every second
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _opacityAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 4.0,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 2.0),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 4.0,
      ),
    ]).animate(_controller);

    _slideAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.1, 0.0), end: const Offset(0.0, 0.0))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 4.0,
      ),
      TweenSequenceItem(tween: ConstantTween(const Offset(0.0, 0.0)), weight: 2.0),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.0, 0.0), end: const Offset(-0.1, 0.0))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 4.0,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  void _startTimer() {
    _animationTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // Reset and restart the animation every second
      if (mounted) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 34.0,
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            shadows: <Shadow>[
              Shadow(
                blurRadius: 30.0,
                color: widget.color,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
