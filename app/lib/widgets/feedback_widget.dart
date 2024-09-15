import 'package:flutter/material.dart';

class FeedbackWidget extends StatefulWidget {
  final String text;
  final Color color;
  final int totalDurationMs; // Duration of the animation feedback in milliseconds.

  const FeedbackWidget({
    super.key,
    required this.text,
    required this.color,
    this.totalDurationMs = 1000,
  });

  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}

class FeedbackWidgetState extends State<FeedbackWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void didUpdateWidget(covariant FeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.color != widget.color) {
      _controller.reset();
      _controller.forward();
    }
  }

  void _initializeAnimations() {
    // Convert duration from milliseconds to seconds
    final durationSeconds = widget.totalDurationMs / 1000.0;
    const fadeDuration = 0.4; // Duration for fade-in and fade-out in seconds
    final constantDisplayDuration = durationSeconds - 2 * fadeDuration;

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.totalDurationMs),
      vsync: this,
    );

    _opacityAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: fadeDuration),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: constantDisplayDuration),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: fadeDuration),
    ]).animate(_controller);

    _slideAnimation = TweenSequence([
      TweenSequenceItem(
          tween:
          Tween(begin: const Offset(0.1, 0.0), end: const Offset(0.0, 0.0))
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: fadeDuration),
      TweenSequenceItem(
          tween: ConstantTween(const Offset(0.0, 0.0)), weight: constantDisplayDuration),
      TweenSequenceItem(
          tween:
          Tween(begin: const Offset(0.0, 0.0), end: const Offset(-0.1, 0.0))
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: fadeDuration),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                Shadow(
                  blurRadius: 30.0,
                  color: widget.color,
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 40.0,
                  color: widget.color,
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 40.0,
                  color: widget.color,
                  offset: const Offset(0, 0),
                ),
              ]),
        ),
      ),
    );
  }
}
