import 'dart:math';

import 'package:Wordle/wordle/wordle_template.dart';
import 'package:flutter/foundation.dart';

import '../word_list/word_lists.dart';

abstract class WordleTemplateSolo extends WordleTemplate {

  const WordleTemplateSolo({super.key, required super.title, required super.language, super.maxAttemps = 6, required super.nbRoundsMax});

  @override
  WordleTemplateSoloState createState();
}

abstract class WordleTemplateSoloState<T extends WordleTemplateSolo> extends WordleTemplateState<T> {

  @override
  void initState() {
    super.initState();
    dictionary = WordLists().getWords(widget.language);
    maxAttemps = widget.maxAttemps;
    language = widget.language;
    _initializeWordle();
  }

  void _initializeWordle() {
    wordle = dictionary[wordleLength].elementAt(Random().nextInt(dictionary[wordleLength].length)).toUpperCase();
    wordleLength = wordle.length;
    if (kDebugMode) print(wordle);
  }

}