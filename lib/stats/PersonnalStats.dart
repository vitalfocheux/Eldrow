import 'package:Wordle/db.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PersonnalStats extends StatefulWidget {

  const PersonnalStats({Key? super.key});

  @override
  State<StatefulWidget> createState() => _PersonnalStatsState();

}

class _PersonnalStatsState extends State<PersonnalStats> {

  Future<List<PieChartSectionData>> _PieChartClassic() async {
    int totalClassic = 0;
    int successClassic = 0;
    final results = await GameResultDatabase.instance.fetchResultsByMode("classic");
    totalClassic = results.length;
    for (var result in results) {
      if (result.success) {
        successClassic++;
      }
    }
    if(totalClassic == 0){
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 100, // Valeur de la section (40%)
          title: '', // Étiquette de la section
          radius: 50,
        ),
      ];
    }
    return [
      PieChartSectionData(
        color: Colors.green,
        value: (successClassic / totalClassic) * 100, // Valeur de la section (40%)
        title: '${(successClassic / totalClassic) * 100}', // Étiquette de la section
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: ((totalClassic - successClassic) / totalClassic) * 100, // Valeur de la section (30%)
        title: '${((totalClassic - successClassic) / totalClassic) * 100}',
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white),
      ),
    ];
  }

  Widget _buildLegend(List<PieChartSectionData> sections){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sections.map((section) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              color: section.color,
            ),
            const SizedBox(width: 8,),
            if(section.color == Colors.green)
              const Text('Success'),
            if(section.color == Colors.red)
              const Text('Failure'),
            if(section.color == Colors.grey)
              const Text('No data'),
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
        title: Text("Graphique en camembert"),
      ),
      body: Center(
        child: FutureBuilder<List<PieChartSectionData>>(
            future: _PieChartClassic(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }else if(snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                return Text('No data found');
              }else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        'Classic mode',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                    SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: snapshot.data!,
                            centerSpaceRadius: 50,
                            sectionsSpace: 2,
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                    ),
                    const SizedBox(height: 20,),
                    _buildLegend(snapshot.data!),
                  ],
                );
              }
            }
        ),
      ),
    );
  }

}