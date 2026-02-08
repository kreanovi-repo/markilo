import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetMarker extends StatelessWidget {
  const SetMarker({
    super.key,
    required this.leftValue,
    required this.rightValue,
    required this.leftColor,
    required this.rightColor,
    required this.onTapLeft,
    required this.onLongPressLeft,
    required this.onTapRight,
    required this.onLongPressRight,
  });

  final int leftValue;
  final int rightValue;
  final Color leftColor;
  final Color rightColor;
  final VoidCallback onTapLeft;
  final VoidCallback onLongPressLeft;
  final VoidCallback onTapRight;
  final VoidCallback onLongPressRight;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    Text buildText(int value, Color color) {
      return Text(
        value.toString(),
        style: GoogleFonts.oswald(
          color: color,
          fontSize: screenHeight * 0.17,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTapLeft,
          onLongPress: onLongPressLeft,
          child: buildText(leftValue, leftColor),
        ),
        SizedBox(width: screenHeight * 0.06),
        GestureDetector(
          onTap: onTapRight,
          onLongPress: onLongPressRight,
          child: buildText(rightValue, rightColor),
        ),
      ],
    );
  }
}
