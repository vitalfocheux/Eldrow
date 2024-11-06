import 'package:Wordle/db.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PersonnalStats extends StatefulWidget {

  const PersonnalStats({Key? super.key});

  @override
  State<StatefulWidget> createState() => _PersonnalStatsState();

}

class _PersonnalStatsState extends State<PersonnalStats> {
  
  Future<Widget> _PieChartMode(String mode) async {
    int total = 0;
    int success = 0;
    final results = await GameResultDatabase.instance.fetchResultsByMode(mode);
    total = results.length;
    for(var result in results){
      if(result.success){
        success++;
      }
    }
    List<PieChartSectionData> sections;
    if(total == 0){
      sections = [
        PieChartSectionData(
          color: Colors.grey,
          value: 100, // Valeur de la section (40%)
          title: '', // Étiquette de la section
          radius: 50,
        ),
      ];
    }else{
      sections = [
        PieChartSectionData(
          color: Colors.green,
          value: (success / total) * 100, // Valeur de la section (40%)
          title: '${(success / total) * 100}', // Étiquette de la section
          radius: 50,
          titleStyle: const TextStyle(color: Colors.white),
        ),
        PieChartSectionData(
          color: Colors.red,
          value: ((total - success) / total) * 100, // Valeur de la section (30%)
          title: '${((total - success) / total) * 100}',
          radius: 50,
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
        SizedBox(
          height: 200,
          child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 50,
                sectionsSpace: 2,
                borderData: FlBorderData(show: false),
              ),
          ),
        ),
        const SizedBox(height: 20,),
        _buildLegend(sections),
      ],
    );
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FutureBuilder<Widget>(
                  future: _PieChartMode("classic"),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }else if(snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }else if(!snapshot.hasData){
                      return Text('No data found');
                    }else{
                      return snapshot.data!;
                    }
                  }
              ),
              FutureBuilder<Widget>(
                  future: _PieChartMode("survival"),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }else if(snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }else if(!snapshot.hasData){
                      return Text('No data found');
                    }else{
                      return snapshot.data!;
                    }
                  }
              ),
            ],
          ),
        ),
      )

    );
  }

}