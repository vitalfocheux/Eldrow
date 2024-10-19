import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Wordle extends StatefulWidget {
  const Wordle({Key? key, required this.title, required this.wordle, this.maxAttemps = 6}) : super(key: key);

  final String title;
  final String wordle;
  final int maxAttemps;

  @override
  State<Wordle> createState() => _WordleState();
}

class _WordleState extends State<Wordle> with SingleTickerProviderStateMixin{

  final TextEditingController _controller = TextEditingController();
  int _attemps = 0;
  String _wordle = '';
  String currentGuess = '';
  int _wordleLength = 0;
  List<String> guesses = [];
  int _maxAttemps = 6;
  final FocusNode _focusNode = FocusNode();
  List<String> words = [];

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _wordle = widget.wordle;
    _wordleLength = _wordle.length;
    _maxAttemps = widget.maxAttemps;
    print(_wordle);

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: -10, end: 10)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_shakeController);

    _shakeController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _shakeController.reset();
      }
    });

    loadWords("assets/dict/french_words.json").then((loadedWords) {
      List<String> filteredWords = [];
      for(var word in loadedWords){
        if(word == "nuage"){
          print("NUAGE lingth = ${word.length}");
        }
        if(word.length == _wordleLength){
          filteredWords.add(word.toUpperCase());
        }
      }
      setState(() {
        words = filteredWords;
      });
    });
  }

  void _shake(String message){
    _shakeController.forward(from: 0);
    _showTemporaryMessage(message);
  }

  void _showTemporaryMessage(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (currentGuess.length == _wordleLength) {
      if(!words.contains(currentGuess)){
        print(words.contains(currentGuess));
        _shake('Not word in list');
        return;
      }
      setState(() {
        guesses.add(currentGuess);
        _attemps++;
        if (currentGuess == _wordle) {
          _showGameOverDialog('Félicitations !', 'Vous avez trouvé le mot !');
        } else if (_attemps >= _maxAttemps) {
          _showGameOverDialog('Game Over', 'Le mot était : $_wordle');
        }
        currentGuess = '';
        _controller.clear();
      });
    }else{
      _shake('Not enough letters');
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

  Future<List<String>> loadWords(String dictionary) async {
    String jsonString = await rootBundle.loadString(dictionary);
    List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<String>();
  }

  bool wordleRules(String wordle){
    if(wordle.length != 5 || !(RegExp(r'^[a-zA-Z]+$').hasMatch(wordle))){
      return false;
    }
    return true;
  }

  void _resetGame() {
    setState(() {
      loadWords("assets/dict/french_words.json").then((words) {
        do{
          _wordle =  (words[Random().nextInt(words.length)]).toUpperCase();
        }while(!wordleRules(_wordle));
      });
      print(_wordle);
      guesses = [];
      currentGuess = '';
      _attemps = 0;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wordle en Flutter'),
      ),
      body: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value+10, 0),
              child: child,
            );
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _wordleLength,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: _maxAttemps * _wordleLength,
                      itemBuilder: (context, index) {
                        int row = index ~/ _wordleLength;
                        int col = index % _wordleLength;
                        String letter = '';
                        Color color = Colors.grey[300]!;

                        if (row < guesses.length) {
                          letter = guesses[row][col];
                          if (letter == _wordle[col]) {
                            color = Colors.green;
                          } else if (_wordle.contains(letter)) {
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Opacity(
                opacity: 0.0,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: _wordleLength,
                  onChanged: (value) {
                    setState(() {
                      currentGuess = value.toUpperCase();
                    });
                  },
                  onSubmitted: (value) {
                    _onSubmit();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}