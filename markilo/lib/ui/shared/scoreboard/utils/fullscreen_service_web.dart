import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// universal_html compila en web y provee stubs seguros en otras plataformas.
import 'package:universal_html/html.dart' as html;

class FullscreenService {
  static bool _isFullscreenMobile = false;

  static bool get isSupported => true;

  static bool get isFullscreen {
    if (kIsWeb) {
      return html.document.fullscreenElement != null;
    }
    return _isFullscreenMobile;
  }

  static Future<void> toggle() async {
    if (kIsWeb) {
      try {
        // En universal_html estas APIs pueden estar tipeadas como void -> NO usar await.
        if (html.document.fullscreenElement == null) {
          html.document.documentElement?.requestFullscreen();
        } else {
          html.document.exitFullscreen();
        }
      } catch (_) {
        // Ignorar errores del browser
      }
      return;
    }

    // Android / iOS / Desktop: fullscreen real de Flutter (barra/nav)
    _isFullscreenMobile = !_isFullscreenMobile;

    if (_isFullscreenMobile) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }
}
