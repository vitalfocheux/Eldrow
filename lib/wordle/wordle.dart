import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Wordle extends StatefulWidget {
  const Wordle({super.key, required this.title, required this.wordle, this.maxAttemps = 6, required this.dictionary});

  final String title;
  final String wordle;
  final int maxAttemps;
  final List<Set<String>> dictionary;

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
  List<Set<String>> _dictionary = [];

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _wordle = widget.wordle;
    _wordleLength = _wordle.length;
    _maxAttemps = widget.maxAttemps;
    _dictionary = widget.dictionary;
    if (kDebugMode) {
      print(_wordle);
    }

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
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
      if(!_dictionary[_wordleLength].contains(currentGuess.toLowerCase())){
        _shake('Not word in list');
        return;
      }
      setState(() {
        guesses.add(currentGuess);
        _attemps++;
        if (currentGuess == _wordle) {
          _showGameOverDialog('Congratulations !', 'You found the word !');
        } else if (_attemps >= _maxAttemps) {
          _showGameOverDialog('Game Over', 'The word was : $_wordle');
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
              child: const Text('Replay'),
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
      _wordle = _dictionary[_wordleLength].elementAt(Random().nextInt(_dictionary[_wordleLength].length)).toUpperCase();
      if (kDebugMode) {
        print(_wordle);
      }
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
        title: const Text('Wordle en Flutter'),
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
                      padding: const EdgeInsets.all(8.0),
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
                              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    child: const Text('Submit'),
                  ),
                  const SizedBox(height: 20),
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