import 'package:Wordle/stats/LastGameHistory.dart';
import 'package:Wordle/stats/PersonnalStats.dart';
import 'package:flutter/material.dart';

class StatPage extends StatefulWidget {

  final String title;

  const StatPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StatPageState();

}

class _StatPageState extends State<StatPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LastGameHistory())
                    );
                  },
                  child: const Text('History of last game'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const PersonnalStats()));
                  },
                  child: const Text('Personnal Stats'),
              ),
            ],
          ),
        ),
      ),
    );
  }


}