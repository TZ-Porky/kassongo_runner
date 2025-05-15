// lib/widgets/pause_game_overlay.dart
import 'package:flutter/material.dart';
import 'package:kassongo_runner/screens/title_screen.dart';
import 'custom_button_elevated.dart';

class PauseGameOverlay extends StatelessWidget {
  final VoidCallback onResumePressed;
  final VoidCallback onOptionsPressed;
  final VoidCallback onQuitPressed;

  const PauseGameOverlay({
    Key? key,
    required this.onResumePressed,
    required this.onOptionsPressed,
    required this.onQuitPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.black.withOpacity(0.9),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'JEU EN PAUSE',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 200,
                height: 50,
                child: CustomButtonElevated(
                  text: 'REPRENDRE',
                  onPressed: onResumePressed,
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.black,
                  borderSide: const BorderSide(color: Colors.black, width: 3),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                height: 50,
                child: CustomButtonElevated(
                  text: 'QUITTER LA PARTIE',
                  onPressed: () {
                    // Naviguer vers le menu principal
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const TitleScreen()), // Utilisez votre écran de menu principal
                    );
                    onQuitPressed?.call(); // Si vous avez d'autres actions à effectuer en quittant
                  },
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.black,
                  borderSide: const BorderSide(color: Colors.black, width: 3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}