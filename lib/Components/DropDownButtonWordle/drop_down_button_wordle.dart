import 'package:flutter/material.dart';

/// DropDownButtonWordle est une classe qui permet de créer un widget où l'on va avoir un titre
/// pour le dropdown et un dropdown avec une liste d'éléments.
class DropDownButtonWordle extends StatelessWidget {

  const DropDownButtonWordle({super.key, required this.title, required this.hint, required this.items, required this.selectedValue, required this.onChanged});

  final String title;
  final String hint;
  final String? selectedValue;
  final Function(String?) onChanged;
  final List<DropdownMenuItem<String>> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title),
          DropdownButton<String>(
            value: selectedValue,
            hint: Text(hint),
            items: items,
            onChanged: onChanged,

          ),
        ],
      ),
    );
  }


}