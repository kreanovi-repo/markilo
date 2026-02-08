import 'package:flutter/widgets.dart';

class ScoreboardShareServiceImpl {
  static Future<bool> shareScoreboard(
    GlobalKey repaintBoundaryKey, {
    String? text,
    double pixelRatio = 3.0,
  }) async {
    // Not supported on this platform.
    return false;
  }
}
