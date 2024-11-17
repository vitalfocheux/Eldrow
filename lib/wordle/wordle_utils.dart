class WordleUtils {

  // Instance unique de la classe WordleUtils (singleton)
  static final WordleUtils _instance = WordleUtils._internal();

  // Constructeur factory pour retourner l'instance unique
  factory WordleUtils() {
    return _instance;
  }

  // Constructeur privé pour initialiser les listes de mots
  WordleUtils._internal();

  // Map associant les codes de langue aux listes de sets de mots
  Map<String, List<Set<String>>> words = {
    'fr': [],
    'en': [],
    'es': [],
    'de': [],
    'it': [],
    'pt': [],
    'sw': [],
  };

  // Méthode pour obtenir les mots d'une langue spécifique
  List<Set<String>> getWords(String language) {
    return words[language]!;
  }
}