import 'package:Wordle/Components/button/button_wordle.dart';
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
        title: const Text(
          'Stats ELDROW',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            const SizedBox(height: 20,),
            ButtonWordle(buttonPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LastGameHistory())
            ), icon: Icons.history, title: 'Last Game History'),
            const SizedBox(height: 50,),
            ButtonWordle(buttonPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonnalStats())
            ), icon: Icons.pie_chart, title: 'Personal Stats'),
          ],
        ),
      ),
    );
  }


}