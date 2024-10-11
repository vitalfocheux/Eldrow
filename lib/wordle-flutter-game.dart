import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(WordleApp());

class WordleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle en Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordleGame(),
    );
  }
}

class WordleGame extends StatefulWidget {
  @override
  _WordleGameState createState() => _WordleGameState();
}

class _WordleGameState extends State<WordleGame> {
  late List<String> wordList = [];
  late String targetWord;
  List<String> guesses = [];
  String currentGuess = '';
  int maxAttempts = 6;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  static Future<List<String>> loadWords(String dictionary) async {
    String jsonString = await rootBundle.loadString(dictionary);
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<String>();
  }

  static bool wordleRules(String wordle){
    if(wordle.length != 5 || !(RegExp(r'^[a-zA-Z]+$').hasMatch(wordle))){
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    loadWords("assets/dict/french_words.json").then((words) {
      do{
        targetWord =  (words[Random().nextInt(words.length)]).toUpperCase();
      }while(!wordleRules(targetWord));
    });
    _focusNode.requestFocus();
  }

  void _onKeyPressed(String letter) {
    if (currentGuess.length < 5) {
      setState(() {
        currentGuess += letter;
        _controller.text = currentGuess;
        _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
      });
    }
  }

  void _onDelete() {
    if (currentGuess.isNotEmpty) {
      setState(() {
        currentGuess = currentGuess.substring(0, currentGuess.length - 1);
        _controller.text = currentGuess;
        _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
      });
    }
  }

  void _onSubmit() {
    if (currentGuess.length == 5) {
      setState(() {
        guesses.add(currentGuess);
        if (currentGuess == targetWord) {
          _showGameOverDialog('Félicitations !', 'Vous avez trouvé le mot !');
        } else if (guesses.length >= maxAttempts) {
          _showGameOverDialog('Game Over', 'Le mot était : $targetWord');
        }
        currentGuess = '';
        _controller.clear();
      });
    }
  }

  void _showGameOverDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Rejouer'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      targetWord = wordList[Random().nextInt(wordList.length)];
      guesses = [];
      currentGuess = '';
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wordle en Flutter'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.0,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: maxAttempts * 5,
              itemBuilder: (context, index) {
                int row = index ~/ 5;
                int col = index % 5;
                String letter = '';
                Color color = Colors.grey[300]!;

                if (row < guesses.length) {
                  letter = guesses[row][col];
                  if (letter == targetWord[col]) {
                    color = Colors.green;
                  } else if (targetWord.contains(letter)) {
                    color = Colors.yellow;
                  } else {
                    color = Colors.grey;
                  }
                } else if (row == guesses.length && col < currentGuess.length) {
                  letter = currentGuess[col];
                }

                return Container(
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              currentGuess,
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            maxLength: 5,
            onChanged: (value) {
              setState(() {
                currentGuess = value.toUpperCase();
              });
            },
            onSubmitted: (value) {
              _onSubmit();
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Entrez votre mot',
              counterText: '',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onSubmit,
            child: Text('Soumettre'),
          ),
        ],
      ),
    );
  }
}