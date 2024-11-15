import 'package:Wordle/wordle/start_classic.dart';
import 'package:Wordle/wordle/start_dual.dart';
import 'package:Wordle/wordle/wordle_survival.dart';
import 'package:flutter/material.dart';

class WordleChoose extends StatefulWidget {

  final String title;

  const WordleChoose({Key? key, required this.title}) : super(key: key);

  @override
  State<WordleChoose> createState() => _WordleChooseState();

}

class _WordleChooseState extends State<WordleChoose> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StartClassic()),
                    );
                  },
                  child: const Text('Classic Wordle'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WordleSurvival(title: 'Survival Wordle', language: 'fr', nbRoundsMax: 0,)),
                    );
                  },
                  child: const Text('Survival Wordle'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StartDual()),
                  );
                },
                child: const Text("Dual Wordle"),
              ),
            ],
          ),
        ),
      ),
    );
  }

}