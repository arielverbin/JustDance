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
  late Key feedbackKey; // Add a Key for the feedback widget

  @override
  void initState() {
    super.initState();
    score = widget.initialScore;
    totalScore = widget.initialTotalScore;
    feedbackKey = UniqueKey(); // Initialize with UniqueKey
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
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

  void updateScore(int newScore) {
    setState(() {
      score = newScore;
      feedbackKey = UniqueKey(); // Update with a new UniqueKey
    });
  }

  void updateTotalScore(int newTotalScore) {
    setState(() {
      totalScore = newTotalScore;
    });
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
      opacity: 0.5, // Adjust opacity as needed
      child: Text(
        '$totalScore',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0, // Adjust the font size for the total score
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500, // Not bold
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
    var (feedback, color) = scoreToFeedback(score);
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
          // Use the feedbackKey here
          FeedbackWidget(
            key: feedbackKey,
            text: feedback,
            color: color,
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
