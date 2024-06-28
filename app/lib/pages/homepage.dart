import 'package:app/pages/game_start_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/widgets/song_card.dart';
import 'package:app/widgets/settings_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late CarouselController _carouselController;
  late int numberOfPlayers;

  @override
  void initState() {
    super.initState();
    numberOfPlayers = 1;
    _carouselController = CarouselController();
  }

  void _onNumberOfPlayersChanged(int newNumberOfPlayers) {
    setState(() {
      numberOfPlayers = newNumberOfPlayers;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The list of songs for the carousel
    final List<Song> songs = [
      Song('Unicorn', 'Noa Kirel', '358936', 'assets/images/background.png'),
      Song('Flowers', 'Miley Cirus', '495863', 'assets/images/background.png'),
      Song('Starships', 'Nicky Minaj', '43609376', 'assets/images/background.png'),
      Song('random', 'Artist 4', 'Best Score 4', 'assets/images/background.png'),
      Song('random', 'Artist 5', 'Best Score 5', 'assets/images/background.png'),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.3, // Set the desired opacity here
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Background Carousel Slider taking most of the screen
          Padding(
            padding: const EdgeInsets.only(left: 350.0, right: 20.0),
            // Adjusted padding
            child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! > 0) {
                    _carouselController.previousPage();
                  } else if (details.primaryDelta! < 0) {
                    _carouselController.nextPage();
                  }
                },
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: songs.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    return SongCard(
                      title: songs[itemIndex].title,
                      artist: songs[itemIndex].artist,
                      bestScore: songs[itemIndex].bestScore,
                      imageUrl: songs[itemIndex].imageUrl,
                      onTap: () {
                        // Call the loadSongService function when a song is tapped
                        // Navigate to InGamePage and pass the song title as an argument
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameStartPage(
                              numberOfPlayers: numberOfPlayers,
                              playerNames: const ['susan', 'noah'],
                              songTitle: songs[itemIndex].title,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    // Adjust the height to fit the screen
                    viewportFraction: 0.8,
                    // Fraction of the viewport to occupy
                    enlargeCenterPage: true,
                    aspectRatio: 1 / 1,
                    // Aspect ratio for the carousel items
                    onPageChanged: (index, reason) {
                      // Callback for page change, add functionality if needed
                    },
                    scrollDirection:
                    Axis.vertical, // Vertical scrolling for carousel
                  ),
                )),
          ),

          // Just Dance logo on the top left corner
          Positioned(
              left: (300 - 150 - 60) / 2,
              // SongCard's margin from left, logo's width.
              top: (300 - 150 - 60) / 2,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/jd-logo.png', // Path to Just Dance logo
                    width: 150,
                  ),
                  const SizedBox(height: 30,),
                  SettingWidget(
                    numberOfPlayers: numberOfPlayers,
                    onNumberOfPlayersChanged: _onNumberOfPlayersChanged,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
