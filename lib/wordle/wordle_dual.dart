import 'package:Wordle/wordle/wordle_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WordleDual extends WordleTemplate {
  const WordleDual({super.key, required super.title, required super.language, super.maxAttemps = 6, required super.nbRoundsMax});

  @override
  _WordleDualState createState() => _WordleDualState();

}

class _WordleDualState extends WordleTemplateState<WordleTemplate> {
  int _nbRounds = 0;
  late int _nbRoundsMax;
  String? _selectedValueAttemps;

  int successP1 = 0;
  int successP2 = 0;

  @override
  void initState() {
    super.initState();
    _nbRoundsMax = widget.nbRoundsMax * 2;
    _nbRounds++;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chooseWord();
    });
  }

  void end() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            successP1 > successP2
                ? 'Player 1 win'
                : successP2 > successP1
                ? 'Player 2 win'
                : 'Draw',
          ),
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
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void chooseWord(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String? selectedValueAttempts = _selectedValueAttemps;
          return AlertDialog(
            title: Text((_nbRounds%2!=0) ? 'Player 1 choose a word and the number of attemps' : 'Player 2 choose a word and the number of attemps'),
            actions: <Widget>[
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Enter a word'),
              ),
              const Text('Choose the number of attemps'),
              DropdownButton<String>(
                value: selectedValueAttempts,
                hint: const Text('Select a value'),
                items: <String>['3', '4', '5', '6', '7', '8', '9'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedValueAttempts = value;
                    maxAttemps = int.parse(value!);
                  });
                },
              ),
              TextButton(
                child: const Text('Next'),
                onPressed: (){
                  String input = controller.text.trim().toUpperCase();
                  if(maxAttemps < 3 || maxAttemps > 9 || input.isEmpty || !(RegExp(r'^[a-zA-Z]+$').hasMatch(input)) || !dictionary[input.length].contains(input.toLowerCase())){
                    null;
                  }else{
                    Navigator.of(context).pop();
                    wordle = input;
                    wordleLength = wordle.length;
                    controller.clear();
                  }
                },
              ),
            ],
          );
        }
    );
  }

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: const Text('Dual Wordle'),
      actions: [
        Text('Round $_nbRounds'),
      ],
    );
  }



  @override
  void checkGame() {
    if (currentGuess == wordle) {
      showGameOverDialog('Congratulations !', 'You found the word !');
      if(_nbRounds%2 != 0){
        successP2++;
      }else{
        successP1++;
      }
    } else if (attemps >= maxAttemps) {
      showGameOverDialog('Game Over', 'The word was : $wordle');
    }
  }

  @override
  void resetGame() {
    setState(() {
      guesses = [];
      currentGuess = '';
      attemps = 0;

      controller.clear();
      if(_nbRounds < _nbRoundsMax){
        chooseWord();
      }else{
        end();
      }
      if (kDebugMode) {
        print("$wordle $_nbRounds P1: $successP1 P2: $successP2");
      }
      ++_nbRounds;
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
              child: const Text('Continue'),
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

}