import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// WordleTemplate est un widget abstrait qui définit le template de base pour le jeu Wordle

abstract class WordleTemplate extends StatefulWidget {
  const WordleTemplate({super.key, required this.language, this.maxAttemps = 6, required this.nbRoundsMax});

  final int maxAttemps;
  final String language;
  final int nbRoundsMax;

  @override
  WordleTemplateState createState();
}

/// WordleTemplateState est un état abstrait qui définit le template de base pour le jeu Wordle

abstract class WordleTemplateState<T extends WordleTemplate> extends State<T> with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  String wordle = '';
  String currentGuess = '';
  late int wordleLength;
  int attemps = 0;
  int maxAttemps = 6;
  List<String> guesses = [];
  List<Set<String>> dictionary = [];
  late String language;

  /// Méthode pour initialiser le jeu Wordle
  @override
  void initState() {
    super.initState();
    _initializeShakeAnimation();
  }

  /// Méthode pour initialiser l'animation de secousse
  void _initializeShakeAnimation() {
    _shakeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _shakeAnimation = Tween<double>(begin: -10, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }

  /// Méthode pour déclencher l'animation de secousse et afficher un message temporaire
  void _shake(String message) {
    _shakeController.forward(from: 0);
    showTemporaryMessage(message);
  }

  /// Méthode pour afficher un message temporaire
  void showTemporaryMessage(String message) {
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

  /// Méthode pour détecter si un mot est dans un dictionnaire ou non
  bool wordleDetection(String guess);

  /// Méthode pour soumettre une tentative
  void _onSubmit() {
    if (currentGuess.length == wordleLength) {
      if(kDebugMode){
        print(dictionary);
      }
      if (!wordleDetection(currentGuess)) {
        _shake('Not word in list');
        return;
      }
      setState(() {
        guesses.add(currentGuess);
        attemps++;
        checkGame();
        currentGuess = '';
        controller.clear();
      });
    } else {
      _shake('Not enough letters');
    }
  }

  /// Méthode pour vérifier l'état du jeu
  void checkGame();

  /// Méthode pour réinitialiser le jeu
  void resetGame();

  ///  Méthode pour afficher une boîte de dialogue de fin de jeu
  void showGameOverDialog(String title, String message);

  /// Méthode pour obtenir le drapeau correspondant à une langue
  Widget getFlag(String language) {
    try {
      return Image.asset(
          'assets/flags/$language.png',
          width: 50.0,
      );
    } catch (e) {
      return Container();
    }
  }

  /// Méthode pour libérer les ressources
  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  /// Méthode pour créer l'appBar
  PreferredSizeWidget appBar();

  /// Méthode pour construire l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
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
                        crossAxisCount: wordleLength,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: maxAttemps * wordleLength,
                      itemBuilder: (context, index) {
                        int row = index ~/ wordleLength;
                        int col = index % wordleLength;
                        String letter = '';
                        Color color = Colors.grey[300]!;

                        if (row < guesses.length) {
                          letter = guesses[row][col];
                          if (letter == wordle[col]) {
                            color = Colors.green;
                          } else if (wordle.contains(letter)) {
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
                  controller: controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: wordleLength,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')),
                  ],
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
