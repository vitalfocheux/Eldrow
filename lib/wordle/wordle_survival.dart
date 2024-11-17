import 'dart:math';

import 'package:Wordle/wordle/wordle_template_solo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../db.dart';
import 'wordle_utils.dart';

class WordleSurvival extends WordleTemplateSolo {
  WordleSurvival({super.key, required super.language, super.maxAttemps = 9, required super.nbRoundsMax, super.wordleLength = 5});

  @override
  _WordleSurvivalState createState() => _WordleSurvivalState();
}

class _WordleSurvivalState extends WordleTemplateSoloState<WordleSurvival> {

  int winStreak = 0;
  bool randomSameLanguage = false;
  bool randomAll = false;

  @override
  void checkGame() {
    if (currentGuess == wordle) {
      showGameOverDialog('Congratulations !', 'You found the word !');
      winStreak++;
      GameResultDatabase.instance.insertGameResult(GameResult(word: wordle, attempts: attemps, success: true, date: DateTime.now(), mode: 'survival', winStreak: winStreak, language: language));
    } else if (attemps >= maxAttemps) {
      showGameOverDialog('Game Over', 'The word was : $wordle and your win streak is $winStreak');
      GameResultDatabase.instance.insertGameResult(GameResult(word: wordle, attempts: attemps, success: false, date: DateTime.now(), mode: 'survival', winStreak: winStreak, language: language));
    }
  }

  @override
  void resetGame() {
    setState(() {
      advance();
      wordle = dictionary[wordleLength].elementAt(Random().nextInt(dictionary[wordleLength].length)).toUpperCase();
      if (kDebugMode) {
        print("$wordle && $winStreak && $randomSameLanguage && $randomAll && $language");
      }
      guesses = [];
      currentGuess = '';
      attemps = 0;
      controller.clear();
    });
  }

  void advance(){
    setState(() {
      if(wordleLength < 9 && (!randomAll || !randomSameLanguage)){
        wordleLength++;
      }
      if(wordleLength == 9 && (!randomAll || !randomSameLanguage)){
        if(maxAttemps > 3){
          maxAttemps--;
        }else if(maxAttemps == 3){
          randomSameLanguage = true;
        }
      }
      if(randomSameLanguage || randomAll){
        maxAttemps = 3 + Random().nextInt(7);
        wordleLength = 3 + Random().nextInt(7);
        if(winStreak == 15){
          randomSameLanguage = false;
          randomAll = true;
        }else if(winStreak > 15){
          randomLanguage();
        }
      }
    });
  }

  void randomLanguage(){
    setState(() {
      switch(Random().nextInt(7)){
        case 0:
          language = 'fr';
          break;
        case 1:
          language = 'en';
          break;
        case 2:
          language = 'es';
          break;
        case 3:
          language = 'de';
          break;
        case 4:
          language = 'it';
          break;
        case 5:
          language = 'pt';
          break;
        case 6:
          language = 'sw';
          break;
      }
      dictionary = WordleUtils().getWords(language);
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
              },
            ),
            TextButton(
              child: Text(winStreak > 0 ? 'Advance' : 'Retry'),
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
  PreferredSizeWidget appBar() {
    return AppBar(
      title: const Text(
          'Survival ELDROW',
          style: TextStyle(
            //fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
      ),
      actions: [
        Text('Win Streak : $winStreak'),
        const SizedBox(width: 10,),
        getFlag(language),
      ],
    );
  }



}