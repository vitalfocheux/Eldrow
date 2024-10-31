import 'package:Wordle/db.dart';
import 'package:flutter/material.dart';

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
        title: Text('History last game'),
      ),
      body: FutureBuilder<List<GameResult>>(
        future: GameResultDatabase.instance.fetchAllResults(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'),);
          }else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return Center(child: Text('No results found'));
          }else{
            final results = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: results.length,
              itemBuilder: (context, index){
                final result = results[index];
                return ListTile(
                  title: Text(result.word),
                  subtitle: Text('${result.attempts} attempts - ${result.success ? 'Success' : 'Failure'}'),
                  trailing: Text(result.date.toIso8601String()),
                );
              },
            );
          }
        },
      )
    );
  }

}