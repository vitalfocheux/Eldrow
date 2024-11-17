import 'package:Wordle/Components/button/button_wordle.dart';
import 'package:Wordle/wordle/start_classic.dart';
import 'package:Wordle/wordle/start_dual.dart';
import 'package:Wordle/wordle/wordle_survival.dart';
import 'package:flutter/material.dart';

/// WordleChoose est une classe qui permet de choisir entre les différents modes de jeu

class WordleChoose extends StatefulWidget {

  final String title;

  const WordleChoose({super.key, required this.title});

  @override
  State<WordleChoose> createState() => _WordleChooseState();

}

class _WordleChooseState extends State<WordleChoose> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Gameplay ELDROW',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ButtonWordle(buttonPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StartClassic()),
                ), icon: Icons.book, title: 'Classic Wordle'),
            const SizedBox(height: 10,),
            ButtonWordle(buttonPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WordleSurvival(language: 'fr', nbRoundsMax: 0,)),
            ), icon: Icons.shield, title: 'Survival Wordle'),
            const SizedBox(height: 10,),
            ButtonWordle(buttonPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StartDual()),
            ), icon: Icons.group, title: 'Dual Wordle'),
          ],
        ),
      ),
    );
  }

}