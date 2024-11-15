// lib/word_lists.dart
class WordLists {
  static final WordLists _instance = WordLists._internal();

  factory WordLists() {
    return _instance;
  }

  WordLists._internal();

  List<Set<String>> frenchWords = [];
  List<Set<String>> englishWords = [];
  List<Set<String>> spanishWords = [];
  List<Set<String>> germanWords = [];
  List<Set<String>> italianWords = [];
  List<Set<String>> portugueseWords = [];
  List<Set<String>> swedishWords = [];

  Map<String, List<Set<String>>> words = {
    'fr': [],
    'en': [],
    'es': [],
    'de': [],
    'it': [],
    'pt': [],
    'sw': [],
  };

  List<Set<String>> getWords(String language) {
    return words[language]!;
  }
}