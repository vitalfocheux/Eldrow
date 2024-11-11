import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class DualWordle extends StatefulWidget {

  const DualWordle({super.key, required this.nbRoundsMax});

  final int nbRoundsMax;

  @override
  State<DualWordle> createState() => _DualWordleState();
}

class _DualWordleState extends State<DualWordle> with SingleTickerProviderStateMixin{

  final TextEditingController _controller = TextEditingController();
  int _attemps = 0;
  String _wordle = '';
  String currentGuess = '';
  int _wordleLength = 5;
  List<String> guesses = [];
  int _maxAttemps = 6;
  final FocusNode _focusNode = FocusNode();
  List<String> words = [];
  late int winStreak;
  bool randomSameLanguage = false;
  bool randomAll = false;
  String language = 'fr';

  int _nbRounds = 0;
  int _nbRoundsMax = 0;

  int successP1 = 0;
  int successP2 = 0;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  String? _selectedValueAttemps;

  @override
  void initState() {
    super.initState();
    _nbRoundsMax = widget.nbRoundsMax * 2;
    _nbRounds++;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chooseWord();
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
      setState(() {
        guesses.add(currentGuess);
        _attemps++;
        if (currentGuess == _wordle) {
          _showGameOverDialog('Congratulations !', 'You found the word !');
          if(_nbRounds%2 != 0){
            successP2++;
          }else{
            successP1++;
          }
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
                controller: _controller,
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
                    _maxAttemps = int.parse(value!);
                  });
                },
              ),
              TextButton(
                child: const Text('Next'),
                onPressed: (){
                  if(_maxAttemps < 3 || _maxAttemps > 9 || _controller.text.trim().isEmpty || !(RegExp(r'^[a-zA-Z]+$').hasMatch(_controller.text))){
                    null;
                  }else{
                    Navigator.of(context).pop();
                    _wordle = _controller.text.trim().toUpperCase();
                    _wordleLength = _wordle.length;
                    _controller.clear();
                  }
                },
              ),
            ],
          );
        }
    );
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
              child: const Text('Continue'),
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
      guesses = [];
      currentGuess = '';
      _attemps = 0;

      _controller.clear();
      if(_nbRounds < _nbRoundsMax){
        chooseWord();
      }else{
        end();
      }
      if (kDebugMode) {
        print("$_wordle $_nbRounds P1: $successP1 P2: $successP2");
      }
      ++_nbRounds;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle en Flutter'),
        actions: [
          Text('Round $_nbRounds'),
        ],
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