import 'package:Wordle/Components/DropDownButtonWordle/drop_down_button_wordle.dart';
import 'package:Wordle/Components/menu_choose_wordle.dart';
import 'package:Wordle/wordle/wordle_dual.dart';
import 'package:flutter/material.dart';

/// StartDual est une classe qui permet de choisir le nombre de rounds pour le mode de jeu Dual Wordle
/// et de lancer le jeu

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
        title: const Text(
            'Dual ELDROW',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ),
      body: Center(
        child: MenuChooseWordle(
            children: [
              DropDownButtonWordle(
                  title: 'Choose the number of rounds',
                  hint: 'Select a value',
                  items: <String>['3', '4', '5', '6', '7', '8', '9'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  selectedValue: _selectedValueRounds,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedValueRounds = value;
                      nbRounds = int.parse(value!);
                    });
                  }),
              ElevatedButton(
                onPressed: () {
                  if(nbRounds > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WordleDual(language: 'fr', nbRoundsMax: nbRounds)),
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