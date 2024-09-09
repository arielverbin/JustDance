import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GraphWidget extends StatefulWidget {
  final List<FlSpot> player1Scores;
  final String player1Name;
  final List<FlSpot> player2Scores;
  final String player2Name;
  final bool isPlayer1Winner;
  final List<double> chorusTimes;

  const GraphWidget({
    super.key,
    required this.player1Scores,
    required this.player1Name,
    required this.player2Scores,
    required this.player2Name,
    required this.isPlayer1Winner,
    required this.chorusTimes,
  });

  @override
  GraphWidgetState createState() => GraphWidgetState();
}

class GraphWidgetState extends State<GraphWidget> {
  List<FlSpot> animatedPlayer1Scores = [];
  List<FlSpot> animatedPlayer2Scores = [];

  late Timer _timer;
  int currentIndex = 1;
  int totalAnimationTime = 1100;
  double _opacity = 0.0;
  late bool singlePlayer;

  @override
  void initState() {
    super.initState();

    singlePlayer = (widget.player2Name == "none") || (widget.player2Name == "");

    // Add the first spot immediately
    animatedPlayer1Scores.add(widget.player1Scores[0]);
    if(!singlePlayer) {
      animatedPlayer2Scores.add(widget.player2Scores[0]);
    }
    startLineDrawingAnimation();

    // Trigger fade-in animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0; // Set opacity to 1 (fully visible)
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startLineDrawingAnimation() {
    // Calculate delay based on the number of spots
    int numberOfSpots = widget.player1Scores.length - 1; // excluding the first spot
    int delayPerSpot = (totalAnimationTime / numberOfSpots).round();

    _timer = Timer.periodic(Duration(milliseconds: delayPerSpot), (timer) {
      if (currentIndex >= widget.player1Scores.length) {
        timer.cancel();
      } else {
        setState(() {
          animatedPlayer1Scores.add(widget.player1Scores[currentIndex]);
          if(!singlePlayer) {
            animatedPlayer2Scores.add(widget.player2Scores[currentIndex]);
          }
          currentIndex++;
        });
      }
    });
  }

  double getMaxX() {
    final allSpots = [...widget.player1Scores, ...widget.player2Scores];
    return allSpots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = [
      const Color(0xff6793e1),
      const Color(0xff7564e1),
      const Color(0xffC65BCF),
      const Color(0xffF27BBD),
    ];

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 500), // Duration of the fade-in animation
      child: Column(
        children: [
          // Legend Row
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: singlePlayer ? [
                GradientLegend(gradientColors, widget.player1Name.toUpperCase())
              ] : [
                // Player 1 (Winner) Legend
                widget.isPlayer1Winner
                    ? GradientLegend(gradientColors, '${widget.player1Name.toUpperCase()} (WINNER)')
                    : GrayLegend(widget.player1Name.toUpperCase()),
                const SizedBox(width: 20),
                // Player 2 Legend
                !widget.isPlayer1Winner
                    ? GradientLegend(gradientColors, '${widget.player2Name.toUpperCase()} (WINNER)')
                    : GrayLegend(widget.player2Name.toUpperCase()),
              ],
            ),
          ),

          // Y-Axis Label and Graph
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Line Chart
                Expanded(
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: animatedPlayer1Scores,
                          isCurved: true,
                          gradient: widget.isPlayer1Winner
                              ? LinearGradient(colors: gradientColors)
                              : null,
                          color: !widget.isPlayer1Winner
                              ? Colors.white.withOpacity(0.5)
                              : null,
                          barWidth: widget.isPlayer1Winner ? 10 : 7,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(show: false),
                          dotData: const FlDotData(show: false),
                        ),
                        LineChartBarData(
                          spots: animatedPlayer2Scores,
                          isCurved: true,
                          gradient: !widget.isPlayer1Winner
                              ? LinearGradient(colors: gradientColors)
                              : null,
                          color: widget.isPlayer1Winner
                              ? Colors.white.withOpacity(0.5)
                              : null,
                          barWidth: widget.isPlayer1Winner ? 7 : 10,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(show: false),
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 20,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white.withOpacity(0.3),
                            strokeWidth: 0.5,
                            dashArray: [5, 5],
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.white.withOpacity(0.3),
                            strokeWidth: 0.5,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              );
                              return Text('${value.toInt()}s', style: style);
                            },
                            interval: 5,
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              );
                              return Text('${value.toInt()}', style: style);
                            },
                            interval: 20,
                            reservedSize: 40,
                          ),
                        ),
                        topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: getMaxX(),
                      minY: 0,
                      maxY: 100,
                      lineTouchData: const LineTouchData(enabled: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // X-Axis Label
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'TIME (SECONDS)',
              style: TextStyle(
                color: Colors.white54,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// Legend for gradient line
class GradientLegend extends StatelessWidget {
  final List<Color> gradientColors;
  final String label;

  const GradientLegend(this.gradientColors, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 10,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }
}

// Legend for gray line
class GrayLegend extends StatelessWidget {
  final String label;

  const GrayLegend(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 10,
          color: Colors.white.withOpacity(0.5),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }
}
