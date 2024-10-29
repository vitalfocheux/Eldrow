import 'package:flutter/material.dart';
import 'package:Wordle/button/start_button.dart';

class StartClassic extends StatefulWidget{
  const StartClassic({super.key});

  @override
  _StartClassicState createState() => _StartClassicState();
}

class _StartClassicState extends State<StartClassic> {

  int wordleLength = 0;
  int wordleAttempts = 0;
  String? _selectedValueLenght;
  String? _selectedValueAttempts;
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classic Wordle'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Choose the length of word'),
            DropdownButton<String>(
              value: _selectedValueLenght,
              hint: const Text('Select a value'),
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
            const Text('Choose the number of attemps'),
            DropdownButton<String>(
              value: _selectedValueAttempts,
              hint: const Text('Select a value'),
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
            const Text('Choose the language'),
            DropdownButton<String>(
                value: _selectedLanguage,
                hint: const Text('Choose a language'),
                items: [
                  DropdownMenuItem(
                      value: 'fr',
                      child: Row(
                        children: [
                          Image.asset('assets/flags/fr.png', width: 24,),
                          const SizedBox(width: 8,),
                          const Text('French'),
                        ],
                      )
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Row(
                      children: [
                        Image.asset('assets/flags/en.png', width: 24,),
                        const SizedBox(width: 8,),
                        const Text('English'),
                      ],
                    )
                  ),
                  DropdownMenuItem(
                      value: 'es',
                      child: Row(
                        children: [
                          Image.asset('assets/flags/es.png', width: 24,),
                          const SizedBox(width: 8,),
                          const Text('Spanish'),
                        ],
                      )
                  ),
                  DropdownMenuItem(
                      value: 'de',
                      child: Row(
                        children: [
                          Image.asset('assets/flags/de.png', width: 24,),
                          const SizedBox(width: 8,),
                          const Text('German'),
                        ],
                      )
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
            ),
            if(_selectedLanguage == 'fr') StartButtonFrench(context, text: 'Start Wordle Classic', wordleLength: wordleLength, maxAttemps: wordleAttempts,),
            if(_selectedLanguage == 'en') StartButtonEnglish(context, text: 'Start Wordle Classic', wordleLength: wordleLength, maxAttemps: wordleAttempts,),
            if(_selectedLanguage == 'es') StartButtonSpanish(context, text: 'Start Wordle Classic', wordleLength: wordleLength, maxAttemps: wordleAttempts,),
            if(_selectedLanguage == 'de') StartButtonGerman(context, text: 'Start Wordle Classic', wordleLength: wordleLength, maxAttemps: wordleAttempts,),
          ],
        ),
      ),
    );
  }
}