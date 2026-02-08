import 'package:flutter/services.dart';

class FullscreenService {
  static bool _isFullscreen = false;
  static bool get isFullscreen => _isFullscreen;

  static Future<void> toggle() async {
    _isFullscreen = !_isFullscreen;

    if (_isFullscreen) {
      // Fullscreen real (ideal para tablets)
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Volver a modo normal
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }
}
