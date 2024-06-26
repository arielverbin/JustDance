import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'ingamepage.dart'; // Import your InGamePage widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      appBar: AppBar(
        title: const Text('Just Dance'),
      ),
      body: Stack(
        children: [
          // Background Carousel Slider taking most of the screen
          Padding(
            padding: const EdgeInsets.only(left: 300.0, right: 20.0), // Adjusted padding
            child: CarouselSlider.builder(
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                return GestureDetector(
                  onTap: () {
                    // Call the loadSongService function when a song is tapped
                    loadSongService(songs[itemIndex].title);
                    // Navigate to InGamePage and pass the song title as an argument
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          numberOfPlayers: 2,
                          playerNames: ['Player1', 'Player2'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0), // Add margin to the bottom of each item
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(songs[itemIndex].imageUrl), // Load the song's image
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7), // Background gradient for text
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              songs[itemIndex].title, // Display song title
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Artist: ${songs[itemIndex].artist}', // Display artist name
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Best Score: ${songs[itemIndex].bestScore}', // Display best score
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height - 100, // Adjust the height to fit the screen
                viewportFraction: 0.8, // Fraction of the viewport to occupy
                enlargeCenterPage: true,
                aspectRatio: 2 / 3, // Aspect ratio for the carousel items
                onPageChanged: (index, reason) {
                  // Callback for page change, add functionality if needed
                },
                scrollDirection: Axis.vertical, // Vertical scrolling for carousel
              ),
            ),
          ),
          // Just Dance logo on the top left corner
          Positioned(
            top: 40.0,
            left: 40.0,
            child: Image.asset(
              'assets/images/jd-logo.png', // Path to Just Dance logo
              width: 200, // Set width of logo
              height: 200, // Set height of logo
            ),
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
