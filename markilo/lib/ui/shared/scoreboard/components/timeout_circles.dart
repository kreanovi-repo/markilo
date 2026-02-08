import 'package:flutter/material.dart';

class TimeoutCircles extends StatelessWidget {
  const TimeoutCircles({
    super.key,
    required this.values,
    required this.borderColor,
    required this.circleSize,
    required this.borderWidth,
    required this.onToggle,
  }) : assert(values.length == 2);

  final List<bool> values;
  final Color borderColor;
  final double circleSize;
  final double borderWidth;
  final void Function(int index) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (index) {
        final active = values[index];
        return GestureDetector(
          onTap: () => onToggle(index),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: circleSize * 0.08),
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? borderColor : Colors.transparent,
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
          ),
        );
      }),
    );
  }
}
