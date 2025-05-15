// lib/screens/loading_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'title_screen.dart'; // Importez l'écran suivant

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Durée de la simulation de chargement
    )..addListener(() {
        setState(() {
          _progressValue = _animationController.value;
        });
      });
    _animationController.forward();

    // Simuler une navigation après la fin du chargement
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TitleScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arrière-plan (dégradé jaune-orange)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFEE58),
                  Color(0xFFFF9800),
                ],
              ),
            ),
          ),
          // Contenu de l'écran de chargement
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'KASSONGO',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Décompression des paquets...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              // Barre de chargement
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(
                  value: _progressValue,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.limeAccent),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Chargement en cours : ${( _progressValue * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}