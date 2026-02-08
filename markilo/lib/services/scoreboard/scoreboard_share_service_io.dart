import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ScoreboardShareServiceImpl {
  static Future<bool> shareScoreboard(
    GlobalKey repaintBoundaryKey, {
    String? text,
    double pixelRatio = 3.0,
  }) async {
    final boundary = repaintBoundaryKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) return false;

    try {
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      // `ByteData` is from `dart:typed_data`. `toByteData` returns `Future<ByteData?>`.
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return false;

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final fileName = 'scoreboard_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = p.join(dir.path, fileName);

      final file = File(filePath);
      await file.writeAsBytes(pngBytes, flush: true);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
      );

      return true;
    } catch (_) {
      return false;
    }
  }
}
