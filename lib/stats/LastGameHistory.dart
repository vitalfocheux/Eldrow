import 'package:Wordle/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// LastGameHistory est une classe qui permet d'afficher l'historique des parties jouées.

class LastGameHistory extends StatefulWidget {

  const LastGameHistory({super.key});

  @override
  State<StatefulWidget> createState() => _LastGameHistoryState();

}

class _LastGameHistoryState extends State<LastGameHistory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'History last game',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
        ),
      ),
      /// Corps de la page avec un FutureBuilder pour afficher les résultats des jeux
      body: FutureBuilder<List<GameResult>>(
        /// Récupération des résultats des jeux depuis la base de données
        future: GameResultDatabase.instance.fetchAllResults(),
        builder: (context, snapshot) {
          /// Affichage d'un indicateur de chargement pendant la récupération des données
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          /// Affichage d'un message d'erreur si une erreur est survenue
          }else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'),);
          /// Affichage d'un message si aucun résultat n'a été trouvé
          }else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('No results found'));
          /// Affichage des résultats des jeux dans une liste
          }else{
            final results = snapshot.data!;
            /// Tri des résultats par date décroissante
            results.sort((a, b) => b.date.compareTo(a.date));
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: results.length,
              itemBuilder: (context, index){
                final result = results[index];
                return ListTile(
                  /// Affichage de l'image du drapeau correspondant à la langue du mot
                  leading: Image.asset('assets/flags/${result.language}.png', width: 40, height: 40,),
                  /// Affichage du mot et du mode de jeu
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.word),
                      Text(result.mode, style: const TextStyle(fontSize: 12, color: Colors.grey),)
                    ],
                  ),
                  /// Affichage du nombre de tentatives et du résultat de la partie
                  subtitle: Text("${result.attempts} ${(result.attempts == 1) ? 'attemp' : 'attemps'} - ${result.success ? 'Success' : 'Failure'}"),
                  /// Affichage de la date du jeu
                  trailing: Text(DateFormat('dd/MM/yyyy HH:mm').format(result.date)),
                );
              },
            );
          }
        },
      )
    );
  }

}