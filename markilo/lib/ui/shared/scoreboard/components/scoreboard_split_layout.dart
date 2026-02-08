import 'package:flutter/material.dart';

class ScoreboardSplitLayout extends StatelessWidget {
  const ScoreboardSplitLayout({
    super.key,
    required this.left,
    required this.right,
    this.topOverlay,
    this.bottomOverlay,
  });

  final Widget left;
  final Widget right;
  final Widget? topOverlay;
  final Widget? bottomOverlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(child: left),
            Expanded(child: right),
          ],
        ),
        if (topOverlay != null)
          Align(
            alignment: Alignment.topCenter,
            child: topOverlay!,
          ),
        if (bottomOverlay != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: bottomOverlay!,
          ),
      ],
    );
  }
}
