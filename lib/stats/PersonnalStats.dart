import 'package:Wordle/db.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// PersonnalStats est une classe qui permet d'afficher les statistiques personnelles de
/// l'utilisateur.

class PersonnalStats extends StatefulWidget {

  const PersonnalStats({super.key});

  @override
  State<StatefulWidget> createState() => _PersonnalStatsState();

}

class _PersonnalStatsState extends State<PersonnalStats> {

  /// Méthode pour créer un graphique en camembert pour un mode donné.
  Future<Widget> _PieChartMode(String mode) async {
    Map<Color, String> sectionsLegend = {};

    int bestStreak = 0;
    int total = 0;
    int success = 0;

    /// Récupération des résultats de la base de données pour un mode donné.
    final results = await GameResultDatabase.instance.fetchResultsByMode(mode);
    total = results.length;
    for(var result in results){
      if(result.success){
        success++;
      }
      if(result.winStreak > bestStreak){
        bestStreak = result.winStreak;
      }
    }
    List<PieChartSectionData> sections;
    if(total == 0){
      sectionsLegend[Colors.grey] = 'No data';
      sections = [
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: '',
          radius: 100,
        ),
      ];
    }else{
      sectionsLegend[Colors.green] = 'Success';
      sectionsLegend[Colors.red] = 'Failure';
      sections = [
        PieChartSectionData(
          color: Colors.green,
          value: (success / total) * 100,
          title: '${((success / total) * 100).toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(color: Colors.white),
        ),
        PieChartSectionData(
          color: Colors.red,
          value: ((total - success) / total) * 100,
          title: '${(((total - success) / total) * 100).toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(color: Colors.white),
        ),
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${mode[0].toUpperCase()}${mode.substring(1)} mode',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 0,
                        sectionsSpace: 0,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  _buildLegend(sectionsLegend),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total: $total',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Success: $success',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if(mode == 'survival') Text(
                      'Best streak: $bestStreak',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
        const SizedBox(height: 50,),
      ],
    );
  }

  /// Méthode pour créer un graphique en camembert pour les langues.
  Future<Widget> _PieChartLanguage() async {
    final results = await GameResultDatabase.instance.fetchAllResults();
    Map<String, int> languages = {};

    Map<Color, String> sectionsLegend = {
      Colors.red: 'fr,French',
      Colors.blue: 'en,English',
      Colors.yellow: 'es,Spanish',
      Colors.black: 'de,German',
      Colors.green: 'it,Italian',
      Colors.purple: 'pt,Portuguese',
      Colors.cyan: 'sw,Swedish',
    };

    for(var result in results){
      if(languages.containsKey(result.language)){
        languages[result.language] = languages[result.language]! + 1;
      }else{
        languages[result.language] = 1;
      }
    }

    List<PieChartSectionData> sections;
    if(languages.isEmpty){
      sections = [
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: '',
          radius: 100,
        ),
      ];
    }else {
      sections = languages.entries.map((entry) {
        return PieChartSectionData(
          color: sectionsLegend.keys.firstWhere((element) => sectionsLegend[element]!.split(',')[0] == entry.key),
          value: (entry.value / languages.values.reduce((a, b) => a + b)) * 100,
          title: '${((entry.value / languages.values.reduce((a, b) => a + b)) * 100).toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(color: Colors.white),
        );
      }).toList();
    }

    sectionsLegend.forEach((key, value) {
      sectionsLegend[key] = value.split(',')[1];
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Languages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 0,
              sectionsSpace: 0,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 20,),
        _buildLegend(sectionsLegend),
        const SizedBox(height: 50,),
      ],
    );
  }

  /// Méthode pour construire la légende du graphique en camembert.
  Widget _buildLegend(Map<Color, String> sections){
    return Wrap(
      alignment: WrapAlignment.center,
    spacing: 16.0,
    runSpacing: 8.0,
    children: sections.entries.map((entry) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            color: entry.key,
          ),
          const SizedBox(width: 8,),
          Text(entry.value),
          const SizedBox(width: 16,)
        ],
      );
    }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Personal stats',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FutureBuilder<Widget>(
                  future: _PieChartMode("classic"),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }else if(snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }else if(!snapshot.hasData){
                      return const Text('No data found');
                    }else{
                      return snapshot.data!;
                    }
                  }
              ),
              FutureBuilder<Widget>(
                  future: _PieChartMode("survival"),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }else if(snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }else if(!snapshot.hasData){
                      return const Text('No data found');
                    }else{
                      return snapshot.data!;
                    }
                  }
              ),
              FutureBuilder<Widget>(
                future: _PieChartLanguage(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  }else if(snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }else if(!snapshot.hasData){
                    return const Text('No data found');
                  }else{
                    return snapshot.data!;
                  }
                }
              )
            ],
          ),
        ),
      )

    );
  }

}