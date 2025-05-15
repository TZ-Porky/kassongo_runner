import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kassongo_runner/screens/end_game_screen.dart';
import 'package:kassongo_runner/screens/title_screen.dart';
import 'package:kassongo_runner/widgets/game_info_bar.dart';
import 'package:kassongo_runner/widgets/pause_game_overlay.dart';

class GameScreen extends StatefulWidget {
  final int level;
  final double initialPlayerSpeed = 100.0;
  final double initialEnemySpeed = 100.0;

  const GameScreen({Key? key, this.level = 1}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  int _score = 2000;
  int _timeLeft = 10;
  String _currentMap = 'Savane Niveau 1';
  bool _isPaused = false;
  bool _gameEnded = false;
  Timer? _timer;

  // Positions et tailles
  double _enemyX = 0.0; // Position initiale de l'ennemi (gauche)
  double _playerX = 0.0; // Position initiale du joueur (gauche)
  double _targetX = 0.0;
  static const double _characterWidth = 50.0;
  static const double _characterHeight = 50.0;
  static const double _bottomPadding = 20.0;
  bool _canCollide = false;


  // Contrôleurs d'animation
  late AnimationController _enemyController;
  late AnimationController _playerController;
  final Random _random = Random(); // Instance de la classe Random
  late double _enemySpeed;
  late double _playerSpeed;

  @override
  void initState() {
    super.initState();
    _initGame();
    // Délai avant d'autoriser les collisions (par exemple, 0.5 seconde)
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted && !_gameEnded) {
        setState(() {
          _canCollide = true;
        });
      }
    });
  }

  void _initGame() {
    // Générer des vitesses aléatoires au démarrage
    _enemySpeed = widget.initialEnemySpeed + _random.nextDouble() * 11; // Vitesse de base + un aléatoire jusqu'à 3
    _playerSpeed = widget.initialPlayerSpeed + _random.nextDouble() * 10; // Vitesse de base + un aléatoire jusqu'à 3

   _enemyController = AnimationController(
      vsync: this,
      duration: Duration(seconds: ((_targetX - 20) / _enemySpeed).toInt().clamp(5, 15)), // Durée basée sur la vitesse aléatoire (avec bornes)
    );
    _playerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: ((_targetX - 20) / _playerSpeed).toInt().clamp(7, 20)), // Durée basée sur la vitesse aléatoire (avec bornes)
    );

    _startTimer();

    // Calcul différé après le premier rendu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _targetX = MediaQuery.of(context).size.width - _characterWidth - 20;
          _currentMap = 'Savane Niveau ${widget.level}';
          _startAnimations();
        });
      }
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_targetX == null) {
      _targetX = MediaQuery.of(context).size.width - _characterWidth - 20;
      _currentMap = 'Savane Niveau ${widget.level}';
      _startAnimations();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && !_gameEnded && _timeLeft > 0) {
        setState(() => _timeLeft--);
      }
    });
  }

  void _startAnimations() {
    _enemyController.animateTo(
      1.0,
      duration: Duration(milliseconds: ((_targetX - 20) / _enemySpeed * 1000).toInt()),
      curve: Curves.linear,
    );

    _playerController.animateTo(
      1.0,
      duration: Duration(milliseconds: ((_targetX - 20) / _playerSpeed * 1000).toInt()),
      curve: Curves.linear,
    );

    _enemyController.addListener(_updateEnemyPosition);
    _playerController.addListener(_updatePlayerPosition);
  }

  void _updateEnemyPosition() {
    if (!mounted || _gameEnded) return;
    setState(() {
      _enemyX = -50 + (_targetX - 20) * _enemyController.value;
      if (_canCollide) {
        _checkCollision();
      }
    });
  }

  void _updatePlayerPosition() {
    if (!mounted || _gameEnded) return;
    setState(() {
      _playerX = 10 + (_targetX - 10) * _playerController.value;
      _checkWinCondition();
    });
  }

  void _pauseGame() {
    if (_gameEnded) return;
    setState(() => _isPaused = true);
    _enemyController.stop();
    _playerController.stop();
  }

  void _resumeGame() {
    setState(() => _isPaused = false);
    _enemyController.forward();
    _playerController.forward();
  }

  void _checkCollision() {
    if ((_enemyX - _playerX).abs() < _characterWidth) {
      _endGame('Le Lion a gagné !');
    }
  }

  void _checkWinCondition() {
    if (_playerX >= _targetX) {
      _endGame('Kassongo a gagné !');
    }
  }

  void _endGame(String result) {
    if (_gameEnded) return;
    _gameEnded = true;
    
    _timer?.cancel();
    _enemyController.stop();
    _playerController.stop();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EndGameScreen(
          gameResult: result,
          coinsCollected: (_score ~/ 200),
          timeLeft: Duration(seconds: _timeLeft),
          totalScore: _score,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _enemyController.dispose();
    _playerController.dispose();
    super.dispose();
  }

  String _getBackgroundAsset() {
    return 'assets/images/${widget.level == 2 ? 'desert' : 'savanna'}_level_${widget.level}.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _getBackgroundAsset(),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey),
          ),
          
          if (!_isPaused)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: GameInfoBar(
                  score: _score,
                  timeLeft: _timeLeft,
                  onPausePressed: _pauseGame,
                  mapName: _currentMap,
                ),
              ),
            ),

          // Personnages
          Positioned(
            left: _enemyX,
            bottom: _bottomPadding,
            child: Container(
              width: _characterWidth,
              height: _characterHeight,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            left: _playerX,
            bottom: _bottomPadding,
            child: Container(
              width: _characterWidth,
              height: _characterHeight,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            left: _targetX,
            bottom: _bottomPadding,
            child: Container(
              width: _characterWidth,
              height: _characterHeight,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),

          if (_isPaused)
            PauseGameOverlay(
              onResumePressed: _resumeGame,
              onOptionsPressed: () => print('Options pressed'),
              onQuitPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TitleScreen()),
              ),
            ),
        ],
      ),
    );
  }
}