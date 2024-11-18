# ELDROW

Eldrow est un équivalent du jeu [Wordle](https://www.nytimes.com/games/wordle/index.html) possédant trois mode de jeu : Classique, Survie & Duel.

## Pour démmarer

Avant tous :

```shell
flutter pub get
```

Faites la commande suivante et choisissez votre devices (à noter que la base de données n'est pas persistente sous le devices web)

```shell
flutter run
```

Si vous voulez démarrez sous le web executer la commande suivante pour ne pas avoir d'erreur sur les statistiques

```shell
flutter run sqflite_common_ffi_web:setup
```

## Mode de jeu

### Classique

Une partie en mode classique, en permettant de choisir le nombre de lettres du mot à deviner, ainsi que le nombre maximum de tentatives, avant de démarrer

### Survie

Une partie en mode survie, c’est-à-dire que les mots à deviner s’enchaînent tant qu’on gagne, les mots devenant de plus en plus longs (et le nombre de tentatives de plus en plus restreint) au fur et à mesure de l’avancée. L’objectif est bien sûr d’aller le plus loin possible.

### Duel

Une partie en mode duel, où deux personnes s’affrontent tour à tour sur le même téléphone. À chaque début de tour, on choisit un mot secret à faire deviner à son adversaire. Le nombre de tours doit être configurable avant de lancer la partie. Le gagnant est bien sûr celui ou celle qui a réussi à trouver le plus de mots (l’égalité est possible).

## Fonctionnalité ajouter

- Ajout du choix de la langue avant de lancer une partie classique
- Le mode survie complexifier, entre 0 et 10 de victoires successives les mots deviennent de plus en plus long avec de moins en moins de tentatives, puis de 10 à 15 de victoires successives tous est au hasard avec des mots en français et enfin à partir de 15 de victoires successives tous est aléatoire même la langue.
- L'ajout de nouvelle langue comme l'italien, le portugais et le suédois grâce à ce [dépôt](https://github.com/eymenefealtun/all-words-in-all-languages) 

## Notes

Lors du chargement de l'application tous les mots se chargent pour les stocker dans une variable, j'ai fait le choix de ne garder que les mots ne possédant que des lettres comprises entre a et z, donc les mots avec accents disparaissent. De même lorsque l'utilisateur soumet un mot aucun accent n'est accepté.

Pour le mode duel l'utilisateur peut indiquer un mot mais il faut qu'il soit valide c'est-à-dire qu'il fasse parti d'un des 7 dictionnaires de mots utiliser par l'application (français, anglais, espagnol, allemand, italien, portugais, suédois)

## Chose à améliorer

La possibilité de voir la partie de entier dans l'historique plutôt que simplement le mot et le résultat