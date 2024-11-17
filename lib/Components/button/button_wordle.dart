import 'package:flutter/material.dart';

class ButtonWordle extends StatelessWidget {

  const ButtonWordle({super.key, required this.buttonPressed, required this.icon, required this.title, this.height = 200.0, this.width = 200.0, this.borderRadius = 10.0});

  final VoidCallback buttonPressed;
  final IconData icon;
  final String title;
  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: buttonPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8,),
            Icon(icon, size: 50,),
            const SizedBox(height: 8,),
            Text(title),
          ],
        ),
      ),
    );
  }



}