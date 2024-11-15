import 'package:Wordle/word_list/word_lists.dart';
import 'package:Wordle/wordle/wordle_dual.dart';
import 'package:flutter/material.dart';

class StartDual extends StatefulWidget{
  const StartDual({super.key});

  @override
  _StartDualState createState() => _StartDualState();
}

class _StartDualState extends State<StartDual> {

  int nbRounds = 0;
  String? _selectedValueRounds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dual Wordle'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Choose the number of rounds'),
            DropdownButton<String>(
              value: _selectedValueRounds,
              hint: const Text('Select a value'),
              items: <String>['3', '4', '5', '6', '7', '8', '9'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedValueRounds = value;
                  nbRounds = int.parse(value!);
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if(nbRounds > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WordleDual(title: 'Dual Wordle', language: 'fr', nbRoundsMax: nbRounds)),
                    );
                  }else{
                    null;
                  }
                },
                child: const Text('Start Dual Wordle'),
            ),
          ],
        ),
      ),
    );
  }
}