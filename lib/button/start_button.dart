import 'dart:math';

import 'package:Wordle/word_list/word_lists.dart';
import 'package:flutter/material.dart';

import '../wordle/wordle.dart';

class StartButton extends StatelessWidget {
  final String text;
  final int wordleLength;
  final int maxAttemps;
  final List<Set<String>> dictionary;

  const StartButton({super.key, required this.text, required this.wordleLength, required this.maxAttemps, required this.dictionary});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (maxAttemps > 0 && wordleLength > 0) ? () {
        String wordle = dictionary[wordleLength].elementAt(Random().nextInt(dictionary[wordleLength].length)).toUpperCase();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Wordle(title: 'Wordle Classic', wordle: wordle, maxAttemps: maxAttemps, dictionary: dictionary,)),
        );
      } : null,
      child: Text(text),
    );
  }
}

class StartButtonFrench extends StartButton {

  StartButtonFrench(context, {super.key, required super.text, required super.wordleLength, required super.maxAttemps}) : super(dictionary: WordLists().frenchWords);
}

class StartButtonEnglish extends StartButton {

  StartButtonEnglish(context, {super.key, required super.text, required super.wordleLength, required super.maxAttemps}) : super(dictionary: WordLists().englishWords);
}

class StartButtonSpanish extends StartButton {

  StartButtonSpanish(context, {super.key, required super.text, required super.wordleLength, required super.maxAttemps}) : super(dictionary: WordLists().spanishWords);
}

class StartButtonGerman extends StartButton {
  StartButtonGerman(context, {super.key, required super.text, required super.wordleLength, required super.maxAttemps}) : super(dictionary: WordLists().germanWords);
}