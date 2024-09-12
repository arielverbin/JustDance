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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void didUpdateWidget(covariant FeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("Widget text  =  " + widget.text);
    print("OLD Widget text  =  " + oldWidget.text);
    if (oldWidget.text != widget.text || oldWidget.color != widget.color) {
      print("wow");
      _controller.reset();
      _controller.forward();
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _opacityAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 4.0),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 2.0),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 4.0),
    ]).animate(_controller);

    _slideAnimation = TweenSequence([
      TweenSequenceItem(
          tween:
              Tween(begin: const Offset(0.1, 0.0), end: const Offset(0.0, 0.0))
                  .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 4.0),
      TweenSequenceItem(
          tween: ConstantTween(const Offset(0.0, 0.0)), weight: 2.0),
      TweenSequenceItem(
          tween:
              Tween(begin: const Offset(0.0, 0.0), end: const Offset(-0.1, 0.0))
                  .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 4.0),
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
    print("Widget text 2 =  " + widget.text);
    print("Widget color 2 =  " + widget.color.toString());

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
