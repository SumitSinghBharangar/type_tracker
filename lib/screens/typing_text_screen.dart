// lib/screens/typing_test_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:type_tracker/provider/typing_provider.dart';
import 'package:type_tracker/screens/result_screen.dart';

class TypingTestScreen extends StatefulWidget {
  const TypingTestScreen({super.key});

  @override
  State<TypingTestScreen> createState() => _TypingTestScreenState();
}

class _TypingTestScreenState extends State<TypingTestScreen> {
  late TextEditingController _controller;
  Timer? _timer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final provider =
            Provider.of<TypingTestProvider>(context, listen: false);
        provider.tick();

        // Check if timer has reached 0 and navigate to results
        if (provider.timeLeft <= 0 && !_hasNavigated) {
          _hasNavigated = true; // Prevent multiple navigations
          _timer?.cancel();
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => const ResultsScreen()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TypingTestProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          provider.isPaused ? Icons.play_arrow : Icons.pause,
                          color: Colors.white,
                        ),
                        onPressed: provider.togglePause,
                      ),
                      Row(
                        children: [
                          _buildAchievement(
                              Icons.pentagon, Colors.orange, '12'),
                          _buildAchievement(
                              Icons.pentagon_outlined, Colors.grey, '6'),
                          _buildAchievement(
                              Icons.horizontal_rule, Colors.purple, '2'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${(provider.timeLeft ~/ 60).toString().padLeft(2, '0')}:${(provider.timeLeft % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          for (int i = 0; i < provider.sampleText.length; i++)
                            TextSpan(
                              text: provider.sampleText[i],
                              style: TextStyle(
                                color: i < provider.userInput.length
                                    ? (i < provider.userInput.length &&
                                            provider.userInput[i] ==
                                                provider.sampleText[i])
                                        ? Colors.green
                                        : Colors.red
                                    : Colors.grey[400],
                                fontSize: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    controller: _controller,
                    onChanged: provider.updateUserInput,
                    enabled: !provider.isPaused && provider.timeLeft > 0,
                    decoration: InputDecoration(
                      hintText: 'Type...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievement(IconData icon, Color color, String count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 4),
          Text(
            count,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
