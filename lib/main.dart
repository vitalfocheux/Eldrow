import 'dart:convert';

import 'package:Wordle/stats/StatPage.dart';
import 'package:Wordle/word_list/word_lists.dart';
import 'package:Wordle/wordle/wordle_choose.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Wordle/wordle/start_classic.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Wordle Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late Future<Database> db;
  List<String> dict = ['assets/dict/french_words.json', 'assets/dict/english_words.json', 'assets/dict/spanish_words.json'];

  static Future<List<String>> loadWords(String dictionary) async {
    String jsonString = await rootBundle.loadString(dictionary);
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<String>();
  }

  bool wordleRules(String wordle){
    if(!(RegExp(r'^[a-zA-Z]+$').hasMatch(wordle))){
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    db = GameResultDatabase.instance.database;
    WidgetsBinding.instance.addObserver(this);
    loadWords("assets/dict/french_words.json").then((words) {
      List<Set<String>> frenchW = [];
      for (String word in words) {
        if (wordleRules(word)) {
          while (frenchW.length <= word.length) {
            frenchW.add({});
          }
          frenchW.elementAt(word.length).add(word);
        }
      }
      setState(() {
        WordLists().frenchWords = frenchW;
      });
    });

    loadWords("assets/dict/english_words.json").then((words) {
      List<Set<String>> englishW = [];
      for (String word in words) {
        if (wordleRules(word)) {
          while (englishW.length <= word.length) {
            englishW.add({});
          }
          englishW.elementAt(word.length).add(word);
        }
      }
      setState(() {
        WordLists().englishWords = englishW;
      });
    });

    loadWords("assets/dict/spanish_words.json").then((words) {
      List<Set<String>> spanishW = [];
      for (String word in words) {
        if (wordleRules(word)) {
          while (spanishW.length <= word.length) {
            spanishW.add({});
          }
          spanishW.elementAt(word.length).add(word);
        }
      }
      setState(() {
        WordLists().spanishWords = spanishW;
      });
    });

    loadWords("assets/dict/german_words.json").then((words) {
      List<Set<String>> germanW = [];
      for (String word in words) {
        if (wordleRules(word)) {
          while (germanW.length <= word.length) {
            germanW.add({});
          }
          germanW.elementAt(word.length).add(word);
        }
      }
      setState(() {
        WordLists().germanWords = germanW;
      });
    });
    GameResultDatabase.instance.fetchAllResults().then((results) {
      if (kDebugMode) {
        print("DB SIZE ${results.length}");
      }
      for(GameResult result in results){
        if (kDebugMode) {
          print('DB : $result');
        }
      }
    });
    /*GameResultDatabase.instance.fetchAllResults().then((results) {
      print('Results');
      for(GameResult result in results){
        print('DB : $result');
      }
    });
    GameResultDatabase.instance.insertGameResult(new GameResult(word: "test", attempts: 6, success: true, date: new DateTime(2024), mode: "classic"));
    GameResultDatabase.instance.fetchAllResults().then((results) {
      print('DB');
      for(GameResult result in results){
        print('DB : $result');
      }
    });*/
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordleChoose(title: 'Gameplay Wordle',)),
                  );
                },
                child: const Text('Choose a gameplay')
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatPage(title: 'Stats Wordle'))
                  );
                },
                child: const Text('Stats Wordle')
            ),
          ],
        ),
      ),
    );
  }
}
