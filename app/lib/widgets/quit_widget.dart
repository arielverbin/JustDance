import 'package:flutter/material.dart';


class QuitWidget extends StatefulWidget {
  final Function() quitGameCallback;

  const QuitWidget({super.key, required this.quitGameCallback});

  @override
  QuitWidgetState createState() => QuitWidgetState();
}

class QuitWidgetState extends State<QuitWidget> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
      ),
      alignment: Alignment.center,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            setState(() {
              clicked = true;
            });
            widget.quitGameCallback();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: clicked ? Colors.white24 : Colors.black45,
          ),
        ),
      ),
    );
  }
}
