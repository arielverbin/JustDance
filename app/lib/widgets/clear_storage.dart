import 'package:app/app_storage.dart';
import 'package:flutter/material.dart';

class ClearStorageWidget extends StatelessWidget {
  final Function() clearAllScores;

  ClearStorageWidget({super.key, required this.clearAllScores});

  final AppStorage appStorage = AppStorage();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConfirmationDialog(context),
      child: Container(
        width: 236,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_forever_rounded,
                color: Colors.white.withOpacity(0.7)),
            const SizedBox(width: 8),
            Text(
              'Clear Storage',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins',
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the confirmation dialog
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ARE YOU SURE?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: const Text(
            'This action will clear all stored data, including all scores.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'CANCEL',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text(
                'CLEAR',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent),
              ),
              onPressed: () {
                appStorage.clearStorage(); // Clear storage
                clearAllScores(); // Call the clearAllScores callback
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
