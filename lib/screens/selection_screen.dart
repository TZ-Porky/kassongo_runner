// lib/screens/selection_screen.dart
import 'package:flutter/material.dart';
import 'package:kassongo_runner/widgets/custom_button_radio.dart';
import 'package:kassongo_runner/widgets/skewed_button_elevated.dart';
import '../widgets/custom_button_elevated.dart';
import 'game_screen.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String? _selectedPlayer = 'lion';
  int _selectedLevel = 1;
  
  void _handleAvatarSelection(String? newValue) {
    setState(() {
      _selectedPlayer = newValue;
      print('Avatar sélectionné : $_selectedPlayer');
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/title_background.png', fit: BoxFit.cover),
          // Titre
          Positioned(
            top: screenHeight * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: const Text(
                'CHOISISSEZ VOTRE JOUEUR',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Conteneur sombre pour la sélection (structure en Row principal)
          Positioned(
            top: screenHeight * 0.2,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            height: screenHeight * 0.55,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white30),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Alignement vertical au centre
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'FELINS',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/lion_avatar.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      CustomButtonRadio(
                        value: 'Lion',
                        groupValue: _selectedPlayer,
                        onChanged: (String? value) {
                          _handleAvatarSelection(value);
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'KASSONGO',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/kassongo_avatar.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 20),
                      CustomButtonRadio(
                        value: 'Kassongo',
                        groupValue: _selectedPlayer,
                        onChanged: (String? value) {
                          _handleAvatarSelection(value);
                        },
                      ),
                    ],
                  ),
                  const VerticalDivider(color: Colors.white70, thickness: 2),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'NIVEAU',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_left,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_selectedLevel > 1) {
                                  _selectedLevel--;
                                }
                              });
                            },
                          ),
                          SizedBox(
                            width: 150,
                            height: 110,
                            child: Image.asset(
                              'assets/images/level_preview.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedLevel++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.2 + screenHeight * 0.55 + 20,
            left: screenWidth * 0.3,
            right: screenWidth * 0.3,
            child: SizedBox(
              height: 60,
              child: SkewedButtonElevated(
                foregroundColor: Colors.black,
                border: Border.all(color: Colors.black, width: 3),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => GameScreen(level: _selectedLevel, player: _selectedPlayer),
                    ),
                  );
                },
                child: const Text(
                  "Commencer",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          // Bouton Retour (en haut à gauche)
          Positioned(
            top: 20,
            left: 25,
            child: SkewedButtonElevated(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                foregroundColor: Colors.black,
                child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 30),
                border: Border.all(color: Colors.black, width: 3),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlayerSelection({
    required String name,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(width: 80, height: 80, child: Image.asset(imagePath)),
        const SizedBox(height: 10),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            color: isSelected ? const Color(0xFFFF9800) : Colors.transparent,
          ),
        ),
      ],
    );
  }
}
