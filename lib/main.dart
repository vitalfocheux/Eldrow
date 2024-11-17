import 'dart:convert';

import 'package:Wordle/Components/button/button_wordle.dart';
import 'package:Wordle/stats/StatPage.dart';
import 'package:Wordle/wordle/wordle_utils.dart';
import 'package:Wordle/wordle/wordle_choose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Wordle Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late Future<Database> db;


  Map<String, List<Set<String>>> words = {
    'fr': [],
    'en': [],
    'es': [],
    'de': [],
    'it': [],
    'pt': [],
    'sw': [],
  };

  // Méthode pour charger les mots depuis un fichier json
  static Future<List<String>> loadWords(String dictionary) async {
    String jsonString = await rootBundle.loadString(dictionary);
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<String>();
  }

  /// Méthode pour vérifier si un mot est valide
  bool wordleRules(String wordle){
    if(!(RegExp(r'^[a-zA-Z]+$').hasMatch(wordle))){
      return false;
    }
    return true;
  }

  /// Méthode pour traiter les mots et les organiser par longueur
  List<Set<String>> _processWords(List<String> words){
    List<Set<String>> processedWords = [];
    for(String word in words){
      if(wordleRules(word)){
        while(processedWords.length <= word.length){
          processedWords.add({});
        }
        processedWords.elementAt(word.length).add(word);
      }
    }
    return processedWords;
  }

  @override
  void initState() {
    super.initState();
    db = GameResultDatabase.instance.database;
    WidgetsBinding.instance.addObserver(this);
    loadWords("assets/dict/french_words.json").then((words) {
      setState(() {
        this.words['fr'] = _processWords(words);
      });
    });

    loadWords("assets/dict/english_words.json").then((words) {
      setState(() {
        this.words['en'] = _processWords(words);
      });
    });

    loadWords("assets/dict/spanish_words.json").then((words) {
      setState(() {
        this.words['es'] = _processWords(words);
      });
    });

    loadWords("assets/dict/german_words.json").then((words) {
      setState(() {
        this.words['de'] = _processWords(words);
      });
    });

    loadWords("assets/dict/italian_words.json").then((words) {
      setState(() {
        this.words['it'] = _processWords(words);
      });
    });

    loadWords("assets/dict/portuguese_words.json").then((words) {
      setState(() {
        this.words['pt'] = _processWords(words);
      });
    });

    loadWords("assets/dict/swedish_words.json").then((words) {
      setState(() {
        this.words['sw'] = _processWords(words);
      });
    });

    setState(() {
      WordleUtils().words = words;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    GameResultDatabase.instance.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.detached){
      GameResultDatabase.instance.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text(
              'ELDROW',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            ButtonWordle(buttonPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WordleChoose(title: 'Gameplay Wordle',)),
            ), icon: Icons.gamepad_outlined, title: 'Choose a gameplay'),
            const SizedBox(height: 50,),
            ButtonWordle(buttonPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatPage(title: 'Stats Wordle'))
            ), icon: Icons.show_chart, title: 'Stats ELDROW'),
          ],
        ),
      ),
    );
  }
}
