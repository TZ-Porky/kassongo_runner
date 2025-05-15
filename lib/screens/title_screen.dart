// lib/screens/title_screen.dart
import 'package:flutter/material.dart';
import 'package:kassongo_runner/widgets/custom_button_elevated.dart';
import 'selection_screen.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/title_background.png',
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 40,
            top: screenHeight * 0.05,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButtonElevated(
                  text: 'COMMENCER',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SelectionScreen()),
                    );
                  },
                  width: 200,
                  height: 50,
                  customShape: TrapezoidShape(),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                const SizedBox(height: 20),
                CustomButtonElevated(
                  text: 'OPTIONS',
                  width: 200,
                  height: 50,
                  customShape: TrapezoidShape(),
                ),
                const SizedBox(height: 20),
                CustomButtonElevated(
                  text: 'TUTORIEL',
                  width: 200,
                  height: 50,
                  customShape: TrapezoidShape(),
                ),
                const SizedBox(height: 20),
                CustomButtonElevated(
                  text: 'ACHIEVEMENTS',
                  width: 200,
                  height: 50,
                  customShape: TrapezoidShape(),
                ),
                const SizedBox(height: 20),
                CustomButtonElevated(
                  text: 'BOUTIQUE',
                  width: 200,
                  height: 50,
                  customShape: TrapezoidShape(),
                ),
              ],
            ),
          ),
          // Informations en haut à droite
          Positioned(
            top: 20,
            right: 20,
            child: Row(
              children: [
                const Text('0/10', style: TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(width: 10),
                Image.asset('assets/images/trophy_icon.png', height: 20),
                const SizedBox(width: 20),
                const Text('2000', style: TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(width: 10),
                Image.asset('assets/images/coin_icon.png', height: 20),
              ],
            ),
          ),
          // Informations en bas à droite
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Version Beta 1.0', style: TextStyle(fontSize: 12, color: Colors.white70)),
                const Text('Développée par le GROUPE 7', style: TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 8),
                const Text('Vous aimez-ce jeu ? N\'oubliez pas de le noter sur notre store.',
                    style: TextStyle(fontSize: 10, color: Colors.white60)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}