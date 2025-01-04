import 'package:flutter/material.dart';
import 'package:type_tracker/common/enum.dart';

class TypingTestProvider with ChangeNotifier {
  bool isPaused = false;
  int timeLeft = 60;
  String userInput = '';
  bool isTestStarted = false;
  int wpm = 0;
  int accuracy = 0;
  DifficultyLevel difficulty = DifficultyLevel.moderate;

  final Map<String, CharacterMetrics> _charMetrics = {};
  DateTime? _lastKeyPressTime;

  final Map<DifficultyLevel, String> _sampleTexts = {
    DifficultyLevel.easy:
        '''The quick brown fox jumps over the lazy dog. This is a simple typing test to help you improve your speed and accuracy. Take your time and focus on getting each word right. Remember to maintain proper typing posture and finger placement on the home row keys.''',
    DifficultyLevel.moderate:
        '''The quick brown fox jumps over the lazy dog. Pack my box with five dozen liquor jugs. How vexingly quick daft zebras jump! The five boxing wizards jump quickly. Programming requires attention to detail and consistent practice to master the fundamentals.''',
    DifficultyLevel.hard:
        '''The quick brown fox jumps over the lazy dog. Pack my box with five dozen liquor jugs. Mr. Jock, TV quiz PhD, bags few lynx. Two driven jocks help fax my big quiz. The job requires extra pluck and zeal from every young wage earner. How vexingly quick daft zebras jump! The five boxing wizards jump quickly.'''
  };

  String get sampleText =>
      _sampleTexts[difficulty] ?? _sampleTexts[DifficultyLevel.moderate]!;

  Map<String, double> get characterSpeeds {
    Map<String, double> speeds = {};

    // First, initialize all characters from sample text with 0 speed
    for (var char in sampleText.toUpperCase().split('')) {
      speeds[char] = 0;
    }

    // Then update with actual speeds for typed characters
    _charMetrics.forEach((char, metrics) {
      if (metrics.occurrences > 0) {
        speeds[char] = metrics.averageSpeed;
      }
    });

    return speeds;
  }

  void setDifficulty(DifficultyLevel level) {
    difficulty = level;
    switch (level) {
      case DifficultyLevel.easy:
        timeLeft = 90;
        break;
      case DifficultyLevel.moderate:
        timeLeft = 60;
        break;
      case DifficultyLevel.hard:
        timeLeft = 30;
        break;
    }
    reset();
  }

  void togglePause() {
    isPaused = !isPaused;
    if (isPaused) {
      _lastKeyPressTime = null;
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
        // Only update metrics if the time difference is reasonable (e.g., less than 5 seconds)
        if (timeDiffMs > 0 && timeDiffMs < 5000) {
          _charMetrics[newChar]!.occurrences++;
          _charMetrics[newChar]!.totalTimeMs += timeDiffMs;
          _charMetrics[newChar]!.lastTypedTime = now;
        }
      }

      _lastKeyPressTime = now;
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
    int totalTime = getDifficultyTime();
    int timeSpent = totalTime - timeLeft;
    if (timeSpent > 0) {
      double words = userInput.length / 5;
      wpm = ((words / timeSpent) * 60).round();
    } else {
      wpm = 0;
    }
  }

  int getDifficultyTime() {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 90;
      case DifficultyLevel.moderate:
        return 60;
      case DifficultyLevel.hard:
        return 30;
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
    timeLeft = getDifficultyTime();
    userInput = '';
    isTestStarted = false;
    wpm = 0;
    accuracy = 0;
    _charMetrics.clear();
    _lastKeyPressTime = null;
    notifyListeners();
  }

  Map<String, double> getSpeedRange() {
    if (_charMetrics.isEmpty) {
      return {'min': 0, 'max': 100};
    }

    double minSpeed = double.infinity;
    double maxSpeed = 0;

    // Only consider characters that have actually been typed
    _charMetrics.forEach((_, metrics) {
      if (metrics.occurrences > 0) {
        double speed = metrics.averageSpeed;
        if (speed > 0) {
          minSpeed = speed < minSpeed ? speed : minSpeed;
          maxSpeed = speed > maxSpeed ? speed : maxSpeed;
        }
      }
    });

    // If no valid speeds were found, return default range
    if (minSpeed == double.infinity || maxSpeed == 0) {
      return {'min': 0, 'max': 100};
    }

    return {
      'min': minSpeed,
      'max':
          maxSpeed * 1.2 // Add 20% padding to the max for better visualization
    };
  }
}

class CharacterMetrics {
  int occurrences = 0;
  double totalTimeMs = 0;
  DateTime? lastTypedTime;

  double get averageSpeed {
    // Only calculate speed if the character has been typed
    if (occurrences > 0 && totalTimeMs > 0) {
      return (occurrences / (totalTimeMs / 1000)) * 60;
    }
    return 0; // Return 0 for untyped characters
  }
}
