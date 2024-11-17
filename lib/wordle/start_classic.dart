import 'package:Wordle/Components/DropDownButtonWordle/drop_down_button_wordle.dart';
import 'package:Wordle/Components/menu_choose_wordle.dart';
import 'package:flutter/material.dart';
import 'package:Wordle/Components/button/start_button.dart';

/// StartClassic est une classe qui permet de choisir la longueur du mot, le nombre d'essais
/// et la langue pour le mode classique

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
  final List<String> _values = <String>['3', '4', '5', '6', '7', '8', '9'];
  final Map<String, String> _languages = {
    'fr': 'French',
    'en': 'English',
    'es': 'Spanish',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'sw': 'Swedish',
  };

  /// Méthode pour créer des éléments de menu déroulants à partir d'une liste de valeurs
  List<DropdownMenuItem<String>> _itemsValues(List<String> items){
    return items.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  /// Méthode pour créer des éléments de menu déroulants à partir d'une map de langues
  List<DropdownMenuItem<String>> _itemsLanguages(Map<String, String> items){
    return items.keys.map((String key) {
      return DropdownMenuItem(
        value: key,
        child: Row(
          children: [
            Image.asset('assets/flags/$key.png', width: 24,),
            const SizedBox(width: 8,),
            Text(items[key]!),
          ],
        )
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Classic Wordle',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            )
        ),
      ),
      body: Center(
        child: MenuChooseWordle(
            children: [
              DropDownButtonWordle(
                  title: 'Choose the length of word',
                  hint: 'Select a value',
                  items: _itemsValues(_values),
                  selectedValue: _selectedValueLenght,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedValueLenght = value;
                      wordleLength = int.parse(value!);
                    });
                  }
              ),
              DropDownButtonWordle(
                  title: 'Choose the number of attemps',
                  hint: 'Select a value',
                  items: _itemsValues(_values),
                  selectedValue: _selectedValueAttempts,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedValueAttempts = value;
                      wordleAttempts = int.parse(value!);
                    });
                  }
              ),
              DropDownButtonWordle(
                  title: 'Choose the language',
                  hint: 'Choose a language',
                  items: _itemsLanguages(_languages),
                  selectedValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  }
              ),
              if(_selectedLanguage != null && _selectedValueLenght != null && _selectedValueAttempts != null) StartButton(text: 'Start Wordle Classic', wordleLength: wordleLength, maxAttemps: wordleAttempts, language: _selectedLanguage!,),
            ],
        ),
      ),
    );
  }
}