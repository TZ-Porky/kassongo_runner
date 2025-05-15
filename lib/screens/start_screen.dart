import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kassongo_runner/screens/loading_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  void initState() {
    super.initState();
    // Simuler un temps de chargement de 3 secondes
    Timer(const Duration(seconds: 3), () {
      // Naviguer vers l'écran de titre après le délai
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoadingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFEE58), Color(0xFFFF9800)],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_boar.png',
                width: 120,
                height: 120,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ), // Réduction de l'espace ici
                child: Text(
                  'KASSONGO',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'Lorsqu\'une vidéo devient plus qu\'un simple meme',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: const Text(
                'Développée par le GROUPE 7',
                style: TextStyle(fontSize: 12, color: Colors.white60),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/logo_stripe.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
