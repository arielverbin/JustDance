import 'package:flutter/material.dart';
import 'dart:async';
import 'homepage.dart'; // Import the HomePage

class WinnerPage extends StatefulWidget {
  @override
  _WinnerPageState createState() => _WinnerPageState();
}

class _WinnerPageState extends State<WinnerPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  // Function to navigate to HomePage after 3 seconds
  void _navigateToHomePage() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Winner!',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
