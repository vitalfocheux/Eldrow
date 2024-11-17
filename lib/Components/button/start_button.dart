import 'package:Wordle/wordle/wordle_classic.dart';
import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  final String text;
  final int wordleLength;
  final int maxAttemps;
  final String language;

  const StartButton({super.key, required this.text, required this.wordleLength, required this.maxAttemps, required this.language});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (maxAttemps > 0 && wordleLength > 0) ? () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WordleClassic(wordleLength: wordleLength, maxAttemps: maxAttemps, language: language, nbRoundsMax: 0,)),
        );
      } : null,
      child: Text(text),
    );
  }
}