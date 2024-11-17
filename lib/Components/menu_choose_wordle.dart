import 'package:flutter/material.dart';

class MenuChooseWordle extends StatelessWidget {

  const MenuChooseWordle({super.key, required this.children, this.borderColor = Colors.black, this.borderWidth = 2.0, this.borderRadius = 8.0});

  final List<Widget> children;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }


}