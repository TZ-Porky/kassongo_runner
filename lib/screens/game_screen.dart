import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kassongo_runner/screens/end_game_screen.dart';
import 'package:kassongo_runner/screens/title_screen.dart';
import 'package:kassongo_runner/widgets/game_info_bar.dart';
import 'package:kassongo_runner/widgets/pause_game_overlay.dart';
import 'package:gif/gif.dart';
import 'package:audioplayers/audioplayers.dart';

class GameScreen extends StatefulWidget {
  // Variables de configuration
  final int level;
  final String? player;
  final double initialPlayerSpeed = 100.0;
  final double initialEnemySpeed = 100.0;

  // Constructeur
  const GameScreen({Key? key, this.level = 1, this.player}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Variables de jeu
  int _score = 2000;
  int _timeLeft = 10;
  String _currentMap = 'Savane Niveau 1';
  String? _playerAvatar;
  bool _isPaused = false;
  bool _gameEnded = false;
  bool _canCollide = false;
  Timer? _timer;

  // Positionnement des personnages
  double _enemyX = 0.0; 
  double _playerX = 0.0;
  double _targetX = 0.0;
  static const double _characterWidth = 100.0;
  static const double _characterHeight = 100.0;
  static const double _bottomPadding = 20.0;
  final Random _random = Random();
  late double _enemySpeed;
  late double _playerSpeed;

  // Contrôleurs d'animation
  late AnimationController _enemyController;
  late AnimationController _playerController;

  // Lecteur audio
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  

  @override
  void initState() {
    super.initState();
    _initGame();
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted && !_gameEnded) {
        setState(() {
          _canCollide = true;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBackgroundMusic();
    });
  }

  void _initGame() {
    // Générer des vitesses aléatoires au démarrage
    _enemySpeed =
        widget.initialEnemySpeed +
        _random.nextDouble() * 11; // Vitesse de base + un aléatoire jusqu'à 3
    _playerSpeed =
        widget.initialPlayerSpeed +
        _random.nextDouble() * 10; // Vitesse de base + un aléatoire jusqu'à 3

    // Intiliser le contrôleur de l'ennemi
    _enemyController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: ((_targetX - 20) / _enemySpeed).toInt().clamp(5, 15),
      ),
    );

    // Initialiser le contrôleur de l'ennemi
    _playerController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: ((_targetX - 20) / _playerSpeed).toInt().clamp(7, 20),
      ),
    );

    // Démarre le timer
    _startTimer();


    _playerAvatar = widget.player;

    // Positionne la cible
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

  // Fonction pour charger la musique de fond
  Future<void> _loadBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.play(AssetSource('audio/bg_music.mp3'));
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print("Erreur lors du chargement/lecture de la musique : $e");
    }
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

  // Fonction pour démarrer le timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && !_gameEnded && _timeLeft > 0) {
        setState(() => _timeLeft--);
      }
    });
  }

  // Fonction pour démarrer les animations
  void _startAnimations() {
    _enemyController.animateTo(
      1.0,
      duration: Duration(
        milliseconds: ((_targetX - 20) / _enemySpeed * 1000).toInt(),
      ),
      curve: Curves.linear,
    );

    _playerController.animateTo(
      1.0,
      duration: Duration(
        milliseconds: ((_targetX - 20) / _playerSpeed * 1000).toInt(),
      ),
      curve: Curves.linear,
    );

    _enemyController.addListener(_updateEnemyPosition);
    _playerController.addListener(_updatePlayerPosition);
  }

  // Fonction pour mettre à jour la position de l'ennemi
  void _updateEnemyPosition() {
    if (!mounted || _gameEnded) return;
    setState(() {
      _enemyX = -80 + (_targetX - 20) * _enemyController.value;
      if (_canCollide) {
        _checkCollision();
      }
    });
  }

  // Fonction pour mettre à jour la position du joueur
  void _updatePlayerPosition() {
    if (!mounted || _gameEnded) return;
    setState(() {
      _playerX = 10 + (_targetX - 10) * _playerController.value;
      _checkWinCondition();
    });
  }

  // Fonction pour mettre en pause le jeu
  void _pauseGame() {
    if (_gameEnded) return;
    setState(() => _isPaused = true);
    _enemyController.stop();
    _playerController.stop();
    _backgroundMusicPlayer.pause(); // Mettre la musique en pause
  }

  // Fonction pour reprendre le jeu
  void _resumeGame() {
    setState(() => _isPaused = false);
    _enemyController.forward();
    _playerController.forward();
    _backgroundMusicPlayer.resume(); // Reprendre la musique
  }

  // Fonction pour vérifier la collision
  void _checkCollision() {
    if (((_enemyX - _playerX).abs() < _characterWidth) && _playerAvatar == 'Lion') {
      _endGame('Le Lion a gagné !');
    } else if ((_enemyX - _playerX).abs() < _characterWidth && _playerAvatar == 'Kassongo') {
      _endGame('Kassongo a perdu !');
    }
  }

  // Fonction pour vérifier la condition de victoire
  void _checkWinCondition() {
    if ((_playerX >= _targetX-10) && (_playerAvatar == 'Kassongo')) {
      _endGame('Kassongo a gagné !');
    } else if (_playerX >= _targetX-10 && _playerAvatar == 'Lion') {
      _endGame('Le Lion a perdu !');
    }
  }

  // Fonction pour gérer la fin du jeu
  Future<void> _endGame(String result) async {
    if (_gameEnded) return;
    _gameEnded = true;

    _timer?.cancel();
    _enemyController.stop();
    _playerController.stop();
    await _backgroundMusicPlayer.stop();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => EndGameScreen(
              gameResult: result,
              coinsCollected: (_score ~/ 200),
              timeLeft: Duration(seconds: _timeLeft),
              totalScore: _score,
            ),
      ),
    );
  }

  // Fonction pour gérer la fin du jeu
  void _onGameEnd() {
    _timer?.cancel();
    _enemyController.stop();
    _playerController.stop();
    _backgroundMusicPlayer.stop();
  }

  @override
  // Fonction de nettoyage
  void dispose() {
    _onGameEnd();
    _enemyController.dispose();
    _backgroundMusicPlayer.dispose();
    _playerController.dispose();
    super.dispose();
  }

  // Fonction pour obtenir le nom de l'image de fond
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
            child: SizedBox(
              width: _characterWidth,
              height: _characterHeight,
              child: Gif(
                autostart: Autostart.loop,
                placeholder:
                    (context) =>
                        const Center(child: CircularProgressIndicator()),
                image: const AssetImage('assets/images/lion.gif'),
              ),
            ),
          ),
          Positioned(
            left: _playerX,
            bottom: _bottomPadding,
            child: SizedBox(
              width: _characterWidth,
              height: _characterHeight,
              child: Gif(
                autostart: Autostart.loop,
                placeholder:
                    (context) =>
                        const Center(child: CircularProgressIndicator()),
                image: const AssetImage('assets/images/boar.gif'),
              ),
            ),
          ),
          Positioned(
            left: _targetX - 20,
            bottom: _bottomPadding - 20,
            child: SizedBox(
              width: _characterWidth * 1.5,
              height: _characterHeight * 1.5,
              child: Image.asset('assets/images/Hole.png'),
            ),
          ),

          if (_isPaused)
            PauseGameOverlay(
              onResumePressed: _resumeGame,
              onOptionsPressed: () => print('Options pressed'),
              onQuitPressed:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TitleScreen(),
                    ),
                  ),
            ),
        ],
      ),
    );
  }
}
