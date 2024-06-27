import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/widgets/song_card.dart'; // Import the SongCard widget
import 'ingamepage.dart'; // Import your InGamePage widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

// Define a class for songs with title, artist, best score, and image URL
class Song {
  String title;
  String artist;
  String bestScore;
  String imageUrl;

  Song(this.title, this.artist, this.bestScore, this.imageUrl);
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The list of songs for the carousel
    final List<Song> songs = [
      Song('Song 1', 'Artist 1', 'Best Score 1', 'assets/images/jd-logo.png'),
      Song('Song 2', 'Artist 2', 'Best Score 2', 'assets/images/jd-logo.png'),
      Song('Song 3', 'Artist 3', 'Best Score 3', 'assets/images/jd-logo.png'),
      Song('Song 4', 'Artist 4', 'Best Score 4', 'assets/images/jd-logo.png'),
      Song('Song 5', 'Artist 5', 'Best Score 5', 'assets/images/jd-logo.png'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1215),
      body: Stack(
        children: [
          // Background Carousel Slider taking most of the screen
          Padding(
            padding: const EdgeInsets.only(left: 300.0, right: 20.0), // Adjusted padding
            child: CarouselSlider.builder(
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                return SongCard(
                  title: songs[itemIndex].title,
                  artist: songs[itemIndex].artist,
                  bestScore: songs[itemIndex].bestScore,
                  imageUrl: songs[itemIndex].imageUrl,
                  onTap: () {
                    // Call the loadSongService function when a song is tapped
                    loadSongService(songs[itemIndex].title);
                    // Navigate to InGamePage and pass the song title as an argument
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          numberOfPlayers: 2,
                          playerNames: const ['Player1', 'Player2'],
                        ),
                      ),
                    );
                  },
                );
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height, // Adjust the height to fit the screen
                viewportFraction: 0.8, // Fraction of the viewport to occupy
                enlargeCenterPage: true,
                aspectRatio: 1 / 1, // Aspect ratio for the carousel items
                onPageChanged: (index, reason) {
                  // Callback for page change, add functionality if needed
                },
                scrollDirection: Axis.vertical, // Vertical scrolling for carousel
              ),
            ),
          ),
          // Just Dance logo on the top left corner
          Image.asset(
              'assets/images/jd-logo.png', // Path to Just Dance logo
              width: 150,
            ),
        ],
      ),
    );
  }

  // Function placeholder: to be implemented for server communication
  void loadSongService(String songID) {
    // TODO: Implement the communication with the server to notify which song is selected
    print('Selected song: $songID');
  }
}
