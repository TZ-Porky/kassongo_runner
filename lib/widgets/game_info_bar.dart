// lib/widgets/game_info_bar.dart
import 'package:flutter/material.dart';
import 'package:kassongo_runner/widgets/custom_button_elevated.dart';

class GameInfoBar extends StatelessWidget {
  final int score;
  final int timeLeft;
  final VoidCallback onPausePressed;
  final String mapName; // Nom de la carte/niveau

  const GameInfoBar({
    Key? key,
    required this.score,
    required this.timeLeft,
    required this.onPausePressed,
    required this.mapName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6), // Fond sombre
        border: Border.all(color: Colors.black, width: 2), // Bordure noire
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            height: 40,
            child: CustomButtonElevated(
              text: '||',
              onPressed: onPausePressed,
              backgroundColor: const Color.fromARGB(225, 255, 153, 0),
              foregroundColor: Colors.white,
              customShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              borderSide: const BorderSide(color: Colors.black, width: 2),
              textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            )
          ),
          Text(
            mapName,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Row(
            children: [
              Text('$score', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Image.asset('assets/images/coin_icon.png', height: 20),
              const SizedBox(width: 16),
              Text('Temps restant: $timeLeft', style: const TextStyle(color: Colors.white, fontSize: 18,)),
            ],
          ),
        ],
      ),
    );
  }
}