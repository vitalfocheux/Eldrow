import 'dart:math';

import 'package:Wordle/wordle/wordle_template_solo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../db.dart';

/// WordleClassic est la classe qui permet de jouer au mode classique du jeu Wordle

class WordleClassic extends WordleTemplateSolo {
  WordleClassic({super.key, required super.wordleLength, required super.language, super.maxAttemps, required super.nbRoundsMax,});

  @override
  _WordleClassicState createState() => _WordleClassicState();
}

class _WordleClassicState extends WordleTemplateSoloState<WordleClassic> {

  @override
  void resetGame() {
    setState(() {
      /// Sélection aléatoire d'un mot dans le dictionnaire
      wordle = dictionary[wordleLength].elementAt(Random().nextInt(dictionary[wordleLength].length)).toUpperCase();
      if (kDebugMode) {
        print(wordle);
      }
      checkGame();
      guesses = [];
      currentGuess = '';
      attemps = 0;
      controller.clear();
    });
  }

  @override
  void showGameOverDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Menu'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Change Parameters'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void checkGame() {
    if (currentGuess == wordle) {
      showGameOverDialog('Congratulations !', 'You found the word !');
      GameResultDatabase.instance.insertGameResult(GameResult(word: wordle, attempts: attemps, success: true, date: DateTime.now(), mode: 'classic', winStreak: 0, language: widget.language));
    } else if (attemps >= maxAttemps) {
      showGameOverDialog('Game Over', 'The word was : $wordle');
      GameResultDatabase.instance.insertGameResult(GameResult(word: wordle, attempts: attemps, success: false, date: DateTime.now(), mode: 'classic', winStreak: 0, language: widget.language));
    }
  }

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: const Text('Classic ELDROW'),
      actions: [
        getFlag(language),
      ],
    );
  }

}
