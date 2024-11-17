import 'dart:math';

import 'package:Wordle/wordle/wordle_template.dart';
import 'package:flutter/foundation.dart';

import 'wordle_utils.dart';

/// WordleTemplateSolo est une classe abstraite qui hérite de WordleTemplate
/// et qui permet de définir un template pour un jeu de Wordle en solo comme
/// le mode classique ou survie

abstract class WordleTemplateSolo extends WordleTemplate {

  WordleTemplateSolo({super.key, required this.wordleLength, required super.language, super.maxAttemps = 6, required super.nbRoundsMax});

  final int wordleLength;

  @override
  WordleTemplateSoloState createState();
}

/// WordleTemplateSoloState est une classe abstraite qui hérite de WordleTemplateState
/// et qui permet de définir un template pour un état de jeu de Wordle en solo comme
/// le mode classique ou survie

abstract class WordleTemplateSoloState<T extends WordleTemplateSolo> extends WordleTemplateState<T> {

  int wordleLength = 5;

  @override
  void initState() {
    super.initState();
    dictionary = WordleUtils().getWords(widget.language);
    maxAttemps = widget.maxAttemps;
    language = widget.language;
    wordleLength = widget.wordleLength;
    _initializeWordle();
  }

  /// Méthode pour initialiser le mot à trouver
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