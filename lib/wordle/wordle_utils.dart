import 'package:flutter/material.dart';

class WordleUtils {
  static final WordleUtils _instance = WordleUtils._internal();

  factory WordleUtils() {
    return _instance;
  }

  WordleUtils._internal();

  List<Set<String>> frenchWords = [];
  List<Set<String>> englishWords = [];
  List<Set<String>> spanishWords = [];
  List<Set<String>> germanWords = [];
  List<Set<String>> italianWords = [];
  List<Set<String>> portugueseWords = [];
  List<Set<String>> swedishWords = [];

  Map<String, List<Set<String>>> words = {
    'fr': [],
    'en': [],
    'es': [],
    'de': [],
    'it': [],
    'pt': [],
    'sw': [],
  };

  List<Set<String>> getWords(String language) {
    return words[language]!;
  }

  SizedBox buttonWordle(VoidCallback buttonPressed, IconData icon, String title, {double width = 200, double height = 200, double borderRadius = 10.0}) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: buttonPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8,),
            Icon(icon, size: 50,),
            const SizedBox(height: 8,),
            Text(title),
          ],
        ),
      ),
    );
  }
}