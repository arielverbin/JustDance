import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CharacterPickWidget extends StatefulWidget {
  final Function(List<String>) updatePlayerSelections;  // Add the callback

  const CharacterPickWidget({super.key, required this.updatePlayerSelections});

  @override
  CharacterPickWidgetState createState() => CharacterPickWidgetState();
}

class CharacterPickWidgetState extends State<CharacterPickWidget> {
  String firstSlotCharacter = "ava";
  String? secondSlotCharacter;

  final List<String> characters = [
    'ava', 'caleb', 'emily', 'liam', 'noah', 'susan'
  ];

  void _openCharacterPicker(BuildContext context, bool isFirstSlot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> availableCharacters = List.from(characters);
        if (isFirstSlot) {
          availableCharacters.remove(secondSlotCharacter);
        } else {
          availableCharacters.remove(firstSlotCharacter);
          availableCharacters.add('none');
        }

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 300),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: availableCharacters.length,
              itemBuilder: (context, index) {
                String character = availableCharacters[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isFirstSlot) {
                        firstSlotCharacter = character;
                      } else {
                        secondSlotCharacter = character == 'none' ? null : character;
                      }
                    });

                    // Update the selected characters
                    List<String> selectedPlayers = [firstSlotCharacter];
                    if (secondSlotCharacter != null) {
                      selectedPlayers.add(secondSlotCharacter!);
                    }

                    // Trigger the callback
                    widget.updatePlayerSelections(selectedPlayers);

                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/characters/$character.svg',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        character.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCharacterSlot(context, true, firstSlotCharacter),
            const SizedBox(width: 16),
            _buildCharacterSlot(context, false, secondSlotCharacter),
          ],
        ),
      ],
    );
  }

  Widget _buildCharacterSlot(BuildContext context, bool isFirstSlot, String? selectedCharacter) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _openCharacterPicker(context, isFirstSlot),
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: selectedCharacter == null || selectedCharacter == 'none'
              ? Center(
            child: Text(
              isFirstSlot ? "Pick" : "Playing\nSingle-Player",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins',
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/characters/$selectedCharacter.svg',
                width: 80,
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
