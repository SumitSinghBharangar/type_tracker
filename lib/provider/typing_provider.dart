import 'package:flutter/material.dart';

class TypingTestProvider with ChangeNotifier {
  bool isPaused = false;
  int timeLeft = 60;
  String userInput = '';
  bool isTestStarted = false;
  int wpm = 0;
  int accuracy = 0;

  // Character metrics tracking
  final Map<String, CharacterMetrics> _charMetrics = {};
  DateTime? _lastKeyPressTime;

  final String sampleText =
      "The quick brown fox jumps over the lazy dog. Pack my box with five dozen liquor jugs. How vexingly quick daft zebras jump! The five boxing wizards jump quickly. Pack my red box with five dozen quality jugs.";

  Map<String, double> get characterSpeeds {
    Map<String, double> speeds = {};
    _charMetrics.forEach((char, metrics) {
      speeds[char] = metrics.averageSpeed;
    });
    return speeds;
  }

  void togglePause() {
    isPaused = !isPaused;
    if (isPaused) {
      _lastKeyPressTime = null; // Reset last key press time when paused
    }
    notifyListeners();
  }

  void updateUserInput(String value) {
    if (isPaused) return;

    if (!isTestStarted && value.isNotEmpty) {
      isTestStarted = true;
      _lastKeyPressTime = DateTime.now();
    }

    // Handle character metrics
    if (value.length > userInput.length) {
      // New character typed
      String newChar = value[value.length - 1].toUpperCase();
      DateTime now = DateTime.now();

      if (_lastKeyPressTime != null) {
        _charMetrics.putIfAbsent(newChar, () => CharacterMetrics());

        double timeDiffMs =
            now.difference(_lastKeyPressTime!).inMilliseconds.toDouble();
        _charMetrics[newChar]!.occurrences++;
        _charMetrics[newChar]!.totalTimeMs += timeDiffMs;
        _charMetrics[newChar]!.lastTypedTime = now;
      }

      _lastKeyPressTime = now;
    } else if (value.length < userInput.length) {
      // Character deleted
      _lastKeyPressTime = DateTime.now();
    }

    userInput = value;
    calculateStats();
    notifyListeners();
  }

  void calculateStats() {
    if (userInput.isEmpty) {
      accuracy = 0;
      wpm = 0;
      return;
    }

    // Calculate accuracy
    int correctChars = 0;
    for (int i = 0; i < userInput.length; i++) {
      if (i < sampleText.length && userInput[i] == sampleText[i]) {
        correctChars++;
      }
    }

    accuracy = ((correctChars / userInput.length) * 100).round();

    // Calculate WPM
    int timeSpent = 60 - timeLeft;
    if (timeSpent > 0) {
      // Use standard word length of 5 characters
      double words = userInput.length / 5;
      wpm = ((words / timeSpent) * 60).round();
    } else {
      wpm = 0;
    }
  }

  void tick() {
    if (!isPaused && isTestStarted && timeLeft > 0) {
      timeLeft--;
      calculateStats();
      notifyListeners();
    }
  }

  void reset() {
    isPaused = false;
    timeLeft = 60;
    userInput = '';
    isTestStarted = false;
    wpm = 0;
    accuracy = 0;
    _charMetrics.clear();
    _lastKeyPressTime = null;
    notifyListeners();
  }

  // Get the fastest and slowest characters for scaling the graph
  Map<String, double> getSpeedRange() {
    if (_charMetrics.isEmpty) {
      return {'min': 0, 'max': 100};
    }

    double minSpeed = double.infinity;
    double maxSpeed = 0;

    _charMetrics.forEach((_, metrics) {
      double speed = metrics.averageSpeed;
      if (speed > 0) {
        minSpeed = speed < minSpeed ? speed : minSpeed;
        maxSpeed = speed > maxSpeed ? speed : maxSpeed;
      }
    });

    return {
      'min': minSpeed == double.infinity ? 0 : minSpeed,
      'max': maxSpeed == 0 ? 100 : maxSpeed * 1.2 // Add 20% padding to max
    };
  }
}

class CharacterMetrics {
  int occurrences = 0;
  double totalTimeMs = 0;
  DateTime? lastTypedTime;

  double get averageSpeed =>
      occurrences > 0 ? (occurrences / (totalTimeMs / 1000)) * 60 : 0;
}
