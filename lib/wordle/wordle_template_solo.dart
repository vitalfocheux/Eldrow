import 'dart:math';

import 'package:Wordle/wordle/wordle_template.dart';
import 'package:flutter/foundation.dart';

import '../word_list/word_lists.dart';

abstract class WordleTemplateSolo extends WordleTemplate {

  WordleTemplateSolo({super.key, required this.wordleLength, required super.title, required super.language, super.maxAttemps = 6, required super.nbRoundsMax});

  final int wordleLength;

  @override
  WordleTemplateSoloState createState();
}

abstract class WordleTemplateSoloState<T extends WordleTemplateSolo> extends WordleTemplateState<T> {

  int wordleLength = 5;

  @override
  void initState() {
    super.initState();
    dictionary = WordLists().getWords(widget.language);
    maxAttemps = widget.maxAttemps;
    language = widget.language;
    wordleLength = widget.wordleLength;
    _initializeWordle();
  }

  void _initializeWordle() {
    wordle = dictionary[wordleLength].elementAt(Random().nextInt(dictionary[wordleLength].length)).toUpperCase();
    wordleLength = wordle.length;
    if (kDebugMode) print(wordle);
  }

  @override
  bool wordleDetection(String guess) {
    return dictionary[wordleLength].contains(guess.toLowerCase());
  }

}