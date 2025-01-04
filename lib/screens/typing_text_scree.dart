import 'package:flutter/material.dart';

class TypingScreen extends StatefulWidget {
  const TypingScreen({super.key});

  @override
  _TypingScreenState createState() => _TypingScreenState();
}

class _TypingScreenState extends State<TypingScreen> {
  final String targetText = "Type this text exactly as shown."; // Text to type
  String typedText = ""; // User-typed text
  FocusNode focusNode = FocusNode(); // To control focus on TextField

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Typing Tracker",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                targetText,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text.rich(
                  TextSpan(
                    children: _getTextSpans(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                focusNode: focusNode,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _handleTyping(value);
                },
                textInputAction: TextInputAction.none, // Prevents line breaks
                keyboardType:
                    TextInputType.visiblePassword, // Prevents autocorrect
                onSubmitted: (_) {
                  focusNode.requestFocus(); // Refocus after Enter key
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Generates text spans to highlight correct and incorrect parts of the typed text
  List<TextSpan> _getTextSpans() {
    List<TextSpan> spans = [];
    for (int i = 0; i < targetText.length; i++) {
      if (i < typedText.length) {
        // Correctly typed character
        if (typedText[i] == targetText[i]) {
          spans.add(
            TextSpan(
              text: targetText[i],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        } else {
          // Incorrectly typed character
          spans.add(
            TextSpan(
              text: targetText[i],
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          );
        }
      } else {
        // Remaining text
        spans.add(
          TextSpan(
            text: targetText[i],
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
    }
    return spans;
  }

  /// Handles typing and disables backspace functionality
  void _handleTyping(String value) {
    if (value.length > typedText.length) {
      setState(() {
        typedText = value;
      });
    } else {
      // Prevents backspace functionality
      focusNode.requestFocus();
    }
  }
}
