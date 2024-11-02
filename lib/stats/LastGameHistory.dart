import 'package:Wordle/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            results.sort((a, b) => b.date.compareTo(a.date));
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: results.length,
              itemBuilder: (context, index){
                final result = results[index];
                return ListTile(
                  leading: Image.asset('assets/flags/${result.language}.png', width: 40, height: 40,),
                  //title: Text(result.word),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.word),
                      Text(result.mode, style: const TextStyle(fontSize: 12, color: Colors.grey),)
                    ],
                  ),
                  subtitle: Text("${result.attempts} ${(result.attempts == 1) ? 'attemp' : 'attemps'} - ${result.success ? 'Success' : 'Failure'}"),
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