import 'package:flutter/material.dart';

class TypingTestProvider with ChangeNotifier {
  bool isPaused = false;
  int timeLeft = 60;
  String userInput = '';
  bool isTestStarted = false;
  int wpm = 0;
  int accuracy = 0;
  int streak = 3;
  int totalWPM = 1432;
  String currentLeague = 'Bronze';
  int topThreeFinishes = 0;

  final String sampleText =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard.";

  void togglePause() {
    isPaused = !isPaused;
    notifyListeners();
  }

  void updateUserInput(String value) {
    if (!isTestStarted && value.isNotEmpty) {
      isTestStarted = true;
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
      int words =
          (userInput.trim().split(' ').where((word) => word.isNotEmpty).length);
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
    notifyListeners();
  }
}
