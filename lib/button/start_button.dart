import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../wordle/wordle.dart';

class StartButton extends StatelessWidget {
  final String text;
  final String dictionary;

  StartButton({required this.text, required this.dictionary});

  static Future<List<String>> loadWords(String dictionary) async {
    String jsonString = await rootBundle.loadString(dictionary);
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<String>();
  }

  static bool wordleRules(String wordle){
    if(wordle.length != 5 || !(RegExp(r'^[a-zA-Z]+$').hasMatch(wordle))){
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        loadWords(dictionary).then((words) {
          String worle = '';
          do{
            worle =  (words[Random().nextInt(words.length)]).toUpperCase();
          }while(!wordleRules(worle));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Wordle(title: 'Wordle Classic', wordle: worle, maxAttemps: 6,)),
          );
        });
      },
      child: Text(text),
    );
  }
}

class StartButtonFrench extends StartButton {

  StartButtonFrench(context, {required text}) : super(text: text, dictionary: 'assets/dict/french_words.json');
}

class StartButtonEnglish extends StartButton {

  StartButtonEnglish(context, {required text}) : super(text: text, dictionary: 'assets/dict/english_words.json');
}

class StartButtonSpanish extends StartButton {

  StartButtonSpanish(context, {required text}) : super(text: text, dictionary: 'assets/dict/spanish_words.json');
}