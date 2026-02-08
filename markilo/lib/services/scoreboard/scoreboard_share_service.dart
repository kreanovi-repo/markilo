import 'package:flutter/widgets.dart';

import 'scoreboard_share_service_stub.dart'
    if (dart.library.io) 'scoreboard_share_service_io.dart';

/// Captures the scoreboard (a [RepaintBoundary]) and opens the platform share sheet.
///
/// Returns `true` when the share flow was launched.
class ScoreboardShareService {
  static Future<bool> shareScoreboard(
    GlobalKey repaintBoundaryKey, {
    String? text,
    double pixelRatio = 3.0,
  }) {
    return ScoreboardShareServiceImpl.shareScoreboard(
      repaintBoundaryKey,
      text: text,
      pixelRatio: pixelRatio,
    );
  }
}
