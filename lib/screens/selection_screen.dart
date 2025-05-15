// lib/screens/selection_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button_elevated.dart';
import 'game_screen.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String _selectedPlayer = 'lion';
  int _selectedLevel = 1;

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
                  // Sélection des joueurs (Column)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildPlayerSelection(
                            name: 'LION',
                            imagePath: 'assets/images/lion_avatar.png',
                            isSelected: _selectedPlayer == 'lion',
                            onTap: () {
                              setState(() {
                                _selectedPlayer = 'lion';
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          _buildPlayerSelection(
                            name: 'KASSONGO',
                            imagePath: 'assets/images/kassongo_avatar.png',
                            isSelected: _selectedPlayer == 'kassongo',
                            onTap: () {
                              setState(() {
                                _selectedPlayer = 'kassongo';
                              });
                            },
                          ),
                        ],
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
          // Bouton Commencer (positionné sous le conteneur sombre)
          Positioned(
            top: screenHeight * 0.2 + screenHeight * 0.55 + 20,
            left: screenWidth * 0.3,
            right: screenWidth * 0.3,
            child: SizedBox(
              height: 40,
              child: CustomButtonElevated(
                text: 'COMMENCER',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => GameScreen(level: _selectedLevel),
                    ),
                  );
                },
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.black,
                customShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Bouton Retour (en haut à gauche)
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
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
