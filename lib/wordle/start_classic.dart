import 'package:flutter/material.dart';
import 'package:Wordle/button/start_button.dart';

class StartClassic extends StatefulWidget{
  @override
  _StartClassicState createState() => _StartClassicState();
}

class _StartClassicState extends State<StartClassic> {

  int wordleLength = 0;
  int wordleAttempts = 0;
  String? _selectedValueLenght;
  String? _selectedValueAttempts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classic Wordle'),
      ),
      body: Center(
        //child: StartButtonFrench(context, text: 'Start Wordle Classic'),
        child: Column(
          children: [
            Text('Choisissez la longueur du mot'),
            DropdownButton<String>(
              value: _selectedValueLenght,
              hint: Text('Choisissez une valeur'),
              items: <String>['3', '4', '5', '6', '7', '8', '9'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedValueLenght = value;
                  wordleLength = int.parse(value!);
                });
              },
            ),
            Text('Choisissez le nombre de tentatives'),
            DropdownButton<String>(
              value: _selectedValueAttempts,
              hint: Text('Choisissez une valeur'),
              items: <String>['3', '4', '5', '6', '7', '8', '9'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedValueAttempts = value;
                  wordleAttempts = int.parse(value!);
                });
              },
            ),
            StartButtonFrench(context, text: 'Start Wordle Classic', wordleLength: wordleLength, maxAttemps: wordleAttempts,),
            /*ElevatedButton(
                onPressed: wordleLength > 0 && wordleAttempts > 0 ? () {
                  StartButtonFrench(context, text: 'Start Wordle Classic', wordleLength: wordleLength, maxAttemps: wordleAttempts,);
                } : null,
                child: Text('Start Wordle Classic'),
            ),*/
          ],
        ),
      ),
    );
  }
}