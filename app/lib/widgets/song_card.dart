import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  final String title;
  final String artist;
  final Map<String, int> bestScores;
  final String imageUrl;
  final int difficulty; // Add difficulty field
  final VoidCallback onTap;

  const SongCard({
    required this.title,
    required this.artist,
    required this.bestScores,
    required this.imageUrl,
    required this.difficulty, // Initialize difficulty field
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, int>> sortedScores = bestScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          decoration: BoxDecoration(
            color: const Color(0xFF0B1215),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.only(left: 40, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artist.toUpperCase(), // Display artist name
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        title.toUpperCase(), // Display song title
                        style: const TextStyle(
                          fontSize: 40.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Add DifficultyIndicator here
                      DifficultyIndicator(difficulty: difficulty),

                      const SizedBox(height: 8.0),
                      // Spacing between difficulty and best score

                      // Best score UI
                      Row(
                        children: [
                          const Text(
                            'BEST SCORE ', // "BEST SCORE" part
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: Colors.white70, // Color for "BEST SCORE"
                            ),
                          ),
                          const Spacer(),

                          ..._scoreLine(sortedScores[0].key, sortedScores[0].value, true)
                        ],
                      ),
                      Column(children: sortedScores.skip(1).map((entry) {
                        return Row(
                            children: [
                            const Spacer(), ..._scoreLine(entry.key, entry.value, false)]
                        );
                      }).toList(),)
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  // Add margin around the image
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    // Round the corners of the image
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _scoreLine(String name, int score, bool lead) {
    return [
        Text(
          '${name.toUpperCase()}  ', // Display player name
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: lead ? Colors.white70 : const Color.fromRGBO(255, 255, 255, 0.3),
          ),
        ),
        Text(
          score.toString(), // Display score
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: lead ? Colors.white : const Color.fromRGBO(255, 255, 255, 0.4),
          ),
        ),
      ];
  }
}

class DifficultyIndicator extends StatelessWidget {
  final int difficulty; // 1 to 4

  const DifficultyIndicator({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "DIFFICULTY ",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
            fontFamily: 'Poppins'
          ),
        ),
        const Spacer(), // Pushes the difficulty squares to the right
        Row(
          children: [
            _buildSquare(Colors.deepOrange, difficulty >= 4, 0),
            _buildSquare(Colors.orangeAccent, difficulty >= 3, 4),
            _buildSquare(Colors.yellowAccent, difficulty >= 2, 4),
            _buildSquare(Colors.greenAccent, difficulty >= 1, 4),
          ],
        ),
      ],
    );
  }

  Widget _buildSquare(Color color, bool isVisible, double margin) {
    return isVisible
        ? Container(
      margin: EdgeInsets.only(left: margin),
      width: 16.0,
      height: 16.0,
      color: color,
    )
        : const SizedBox.shrink(); // If not visible, use an empty widget
  }
}
