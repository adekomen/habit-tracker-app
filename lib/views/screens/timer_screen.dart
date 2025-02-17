import 'package:flutter/material.dart';
import 'dart:async';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  bool _isRunning = false; // Pour vérifier si le chronomètre est en cours d'exécution
  int _secondsElapsed = 0; // Temps écoulé en secondes
  int _countdownTime = 0; // Temps défini pour le compte à rebours
  Timer? _timer; // Timer pour mettre à jour le chronomètre (nullable pour éviter l'erreur)
  final List<String> _recordedTimes = []; // Liste pour enregistrer les temps
  late AnimationController _animationController; // Contrôleur d'animation
  late Animation<double> _animation; // Animation pour le design

  // Variables pour le compte à rebours
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annuler le timer s'il est initialisé
    _animationController.dispose(); // Libérer le contrôleur d'animation
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _animationController.repeat(reverse: true); // Démarrer l'animation
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownTime > 0) {
            _countdownTime--;
            if (_countdownTime == 0) {
              _stopTimer();
              _recordedTimes.add('Compte à rebours terminé');
            }
          } else {
            _secondsElapsed++;
          }
        });
      });
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      _isRunning = false;
      _animationController.stop(); // Arrêter l'animation
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _secondsElapsed = 0;
      _countdownTime = 0;
      _hours = 0;
      _minutes = 0;
      _seconds = 0;
    });
    _timer?.cancel();
    _animationController.reset();
  }

  void _setCountdownTime() {
    setState(() {
      _countdownTime = _hours * 3600 + _minutes * 60 + _seconds;
    });
  }

  void _recordTime() {
    setState(() {
      _recordedTimes.add(_formatTime(_secondsElapsed));
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade400],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Affichage du temps (chronomètre ou compte à rebours)
              ScaleTransition(
                scale: _animation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _countdownTime > 0 ? _formatTime(_countdownTime) : _formatTime(_secondsElapsed),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Section Compte à rebours (heures, minutes, secondes)
              if (_countdownTime > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeInput('Heures', _hours, (value) {
                      setState(() {
                        _hours = value;
                      });
                    }),
                    const SizedBox(width: 10),
                    _buildTimeInput('Minutes', _minutes, (value) {
                      setState(() {
                        _minutes = value;
                      });
                    }),
                    const SizedBox(width: 10),
                    _buildTimeInput('Secondes', _seconds, (value) {
                      setState(() {
                        _seconds = value;
                      });
                    }),
                  ],
                ),
              const SizedBox(height: 20),

              // Boutons Démarrer/Arrêter et Réinitialiser
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isRunning ? _stopTimer : _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isRunning ? Icons.stop : Icons.play_arrow,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isRunning ? 'Arrêter' : 'Démarrer',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Réinitialiser',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bouton Compte à rebours
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Définir un compte à rebours'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTimeInput('Heures', _hours, (value) {
                              setState(() {
                                _hours = value;
                              });
                            }),
                            _buildTimeInput('Minutes', _minutes, (value) {
                              setState(() {
                                _minutes = value;
                              });
                            }),
                            _buildTimeInput('Secondes', _seconds, (value) {
                              setState(() {
                                _seconds = value;
                              });
                            }),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              _setCountdownTime();
                              Navigator.pop(context);
                            },
                            child: const Text('Démarrer'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Compte à rebours',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section Enregistrements récents
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Enregistrements récents :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._recordedTimes.map((time) => Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour saisir les heures, minutes et secondes
  Widget _buildTimeInput(String label, int value, Function(int) onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (text) {
              int newValue = int.tryParse(text) ?? 0;
              onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }
}