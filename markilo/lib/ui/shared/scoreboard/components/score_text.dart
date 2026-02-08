import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreText extends StatelessWidget {
  const ScoreText({
    super.key,
    required this.value,
    required this.color,
    required this.fontSize,
    this.baseline,
    this.onTap,
    this.onLongPress,
    this.padLeft = 2,
  });

  final int value;
  final Color color;
  final double fontSize;
  final double? baseline;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final int padLeft;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      value.toString().padLeft(padLeft, '0'),
      style: GoogleFonts.oswald(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );

    final wrapped = (baseline != null)
        ? Baseline(
            baseline: baseline!,
            baselineType: TextBaseline.alphabetic,
            child: text,
          )
        : text;

    if (onTap == null && onLongPress == null) {
      return wrapped;
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: wrapped,
    );
  }
}
