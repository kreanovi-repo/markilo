import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.teal,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(foregroundColor),
            backgroundColor: WidgetStateProperty.all(backgroundColor)),
        onPressed: () => onPressed(),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ));
  }
}
