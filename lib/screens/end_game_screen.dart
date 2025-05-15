// lib/screens/end_game_screen.dart
import 'package:flutter/material.dart';
import 'package:kassongo_runner/screens/selection_screen.dart';
import 'package:kassongo_runner/screens/title_screen.dart';
import '../widgets/custom_button_elevated.dart';

class EndGameScreen extends StatelessWidget {
  final String gameResult;
  final int coinsCollected;
  final Duration timeLeft;
  final int totalScore;

  const EndGameScreen({
    Key? key,
    required this.gameResult,
    required this.coinsCollected,
    required this.timeLeft,
    required this.totalScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/default_background.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'FIN DE LA PARTIE',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        gameResult.toUpperCase(),
                        style: TextStyle(fontSize: 20, color: Colors.yellow),
                      ),
                      const SizedBox(height: 24),
                      _buildResultRow(
                        'PIÈCES COLLECTÉES',
                        '${coinsCollected} x 50',
                        fontSize: 18,
                      ),
                      _buildResultRow(
                        'TEMPS RESTANT',
                        '${timeLeft.inMinutes}:${(timeLeft.inSeconds % 60).toString().padLeft(2, '0')} x 100',
                        fontSize: 18,
                      ),
                      _buildResultRow(
                        'TOTAL SCORE',
                        '$totalScore',
                        isBold: true,
                        fontSize: 24,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomButtonElevated(
                            text: 'SUIVANT',
                            width: 170,
                            backgroundColor: const Color(0xFFFF9800),
                            onPressed:
                                () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SelectionScreen(),
                                  ),
                                ),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),
                          CustomButtonElevated(
                            text: 'REJOUER',
                            backgroundColor: const Color(0xFFFF9800),
                            width: 170,
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),
                          CustomButtonElevated(
                            text: 'MENU',
                            width: 170,
                            backgroundColor: const Color(0xFFFF9800),
                            onPressed:
                                () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TitleScreen(),
                                  ),
                                ),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 20,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
