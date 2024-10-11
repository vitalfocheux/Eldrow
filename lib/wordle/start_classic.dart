import 'package:flutter/material.dart';
import 'package:Wordle/button/start_button.dart';

class StartClassic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classic Wordle'),
      ),
      body: Center(
        child: StartButtonFrench(context, text: 'Start Wordle Classic'),
      ),
    );
  }
}