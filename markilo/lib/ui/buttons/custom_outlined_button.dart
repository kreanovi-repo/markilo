import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final double hPadding;
  final double vPadding;
  final double fontSize;
  final bool isFilled;

  const CustomOutlinedButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color = Colors.blue,
      this.isFilled = false,
      this.hPadding = 20.0,
      this.vPadding = 10.0,
      this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          side: WidgetStateProperty.all(BorderSide(color: color)),
          backgroundColor: WidgetStateProperty.all(
              isFilled ? color.withOpacity(0.3) : Colors.transparent)),
      onPressed: () => onPressed(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
        child: Text(
          text,
          style: TextStyle(
              fontSize: fontSize, color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
