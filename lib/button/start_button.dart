import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../wordle/wordle.dart';

class StartButton extends StatelessWidget {
  final String text;
  final String dictionary;
  final int wordleLength;
  final int maxAttemps;

  StartButton({required this.text, required this.dictionary, required this.wordleLength, required this.maxAttemps});

  static Future<List<String>> loadWords(String dictionary) async {
    String jsonString = await rootBundle.loadString(dictionary);
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<String>();
  }

  bool wordleRules(String wordle){
    if(wordle.length != wordleLength || !(RegExp(r'^[a-zA-Z]+$').hasMatch(wordle))){
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (maxAttemps > 0 && wordleLength > 0) ? () {
        loadWords(dictionary).then((words) {
          String worle = '';
          do{
            worle =  (words[Random().nextInt(words.length)]).toUpperCase();
          }while(!wordleRules(worle));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Wordle(title: 'Wordle Classic', wordle: worle, maxAttemps: maxAttemps,)),
          );
        });
      } : null,
      child: Text(text),
    );
  }
}

class StartButtonFrench extends StartButton {

  StartButtonFrench(context, {required text, required wordleLength, required maxAttemps}) : super(text: text, dictionary: 'assets/dict/french_words.json', wordleLength: wordleLength, maxAttemps: maxAttemps);
}

class StartButtonEnglish extends StartButton {

  StartButtonEnglish(context, {required text}) : super(text: text, dictionary: 'assets/dict/english_words.json', wordleLength: 5, maxAttemps: 10);
}

class StartButtonSpanish extends StartButton {

  StartButtonSpanish(context, {required text}) : super(text: text, dictionary: 'assets/dict/spanish_words.json', wordleLength: 6, maxAttemps: 10);
}