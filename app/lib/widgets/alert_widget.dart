import 'package:flutter/material.dart';

class AlertWidget extends StatefulWidget {
  final Icon icon;
  final Color color;
  final String title;
  final String content;
  final int duration;
  static bool isShowing = false;
  final int dissolveDuration = 300;

  const AlertWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.content,
    required this.duration,
  });

  @override
  AlertWidgetState createState() => AlertWidgetState();

  static void showError(BuildContext context, AlertWidget errorWidget) {
    if (!isShowing) {
      isShowing = true;
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: errorWidget,
          ),
        ),
      );

      overlay.insert(overlayEntry);
      Future.delayed(Duration(milliseconds: errorWidget.duration * 1000 + errorWidget.dissolveDuration), () {
        overlayEntry.remove();
        isShowing = false;
      });
    }
  }
}

class AlertWidgetState extends State<AlertWidget> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeIn();
    _scheduleFadeOut();
  }

  void _fadeIn() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  void _scheduleFadeOut() {
    Future.delayed(Duration(seconds: widget.duration), () {
      setState(() {
        _opacity = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: widget.dissolveDuration),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Wrap(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.icon,
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.content,
                        style: const TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ],
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