import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/widgets/feedback_widget.dart';

class ScoreWidget extends StatefulWidget {
  final String playerName;
  final int initialScore;
  final int initialTotalScore;
  final Alignment alignment;
  final int playerIndex;

  const ScoreWidget({
    required Key key,
    required this.playerIndex,
    required this.playerName,
    required this.initialScore,
    required this.initialTotalScore,
    required this.alignment,
  }) : super(key: key);

  @override
  ScoreWidgetState createState() => ScoreWidgetState();
}

class ScoreWidgetState extends State<ScoreWidget> {
  late int score;
  late int totalScore;
  late String feedbackText;
  late Color feedbackColor;

  @override
  void initState() {
    super.initState();
    score = widget.initialScore;
    totalScore = widget.initialTotalScore;
    var (initialFeedback, initialColor) = scoreToFeedback(score);
    feedbackText = initialFeedback;
    feedbackColor = initialColor;
  }

  /// Updates the score smoothly (called frequently)
  void updateScore(int newScore, int newTotalScore) {
    setState(() {
      score = newScore;
      totalScore = newTotalScore;
    });
  }

  /// Triggers the feedback update (called once per second)
  void triggerFeedback() {
    setState(() {
      var (feedback, color) = scoreToFeedback(score);
      feedbackText = feedback;
      feedbackColor = color;
    });
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  (String, Color) scoreToFeedback(int value) {
    if (value >= 80) {
      return ("PERFECT", Colors.cyanAccent);
    } else if (value >= 60) {
      return ("GOOD", Colors.indigoAccent);
    } else if (value >= 40) {
      return ("OK", Colors.lightGreen);
    } else if (value >= 20) {
      return ("NAH", Colors.orange);
    } else {
      return ("X", Colors.redAccent);
    }
  }

  Widget getScoreTitle() {
    var nameWidget = Text(
      capitalize(widget.playerName),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
      ),
    );

    var scoreWidget = Opacity(
      opacity: 0.5,
      child: Text(
        '$totalScore',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    if (widget.playerIndex == -1) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [scoreWidget, const SizedBox(width: 10), nameWidget],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [nameWidget, const SizedBox(width: 10), scoreWidget],
    );
  }

  @override
  Widget build(BuildContext context) {
    var scoreTitleWidget = getScoreTitle();

    List<Widget> rowChildren = [
      Transform.scale(
        scaleX: widget.playerIndex.toDouble(),
        child: SvgPicture.asset(
          'assets/characters/${widget.playerName}.svg',
          height: 100,
        ),
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: widget.alignment == Alignment.topLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          scoreTitleWidget,
          FeedbackWidget(
            text: feedbackText,
            color: feedbackColor,
          ),
        ],
      ),
    ];

    if (widget.playerIndex == -1) {
      rowChildren = rowChildren.reversed.toList();
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      ),
    );
  }
}