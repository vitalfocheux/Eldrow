import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:Wordle/word_list/word_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../wordle/wordle.dart';

class StartButton extends StatelessWidget {
  final String text;
  final int wordleLength;
  final int maxAttemps;
  final List<Set<String>> dictionary;

  StartButton({required this.text, required this.wordleLength, required this.maxAttemps, required this.dictionary});

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

  StartButtonFrench(context, {required text, required wordleLength, required maxAttemps}) : super(text: text, wordleLength: wordleLength, maxAttemps: maxAttemps, dictionary: WordLists().frenchWords);
}

class StartButtonEnglish extends StartButton {

  StartButtonEnglish(context, {required text, required wordleLength, required maxAttemps}) : super(text: text, wordleLength: wordleLength, maxAttemps: maxAttemps, dictionary: WordLists().englishWords);
}

class StartButtonSpanish extends StartButton {

  StartButtonSpanish(context, {required text, required wordleLength, required maxAttemps}) : super(text: text, wordleLength: wordleLength, maxAttemps: maxAttemps, dictionary: WordLists().spanishWords);
}