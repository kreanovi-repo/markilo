import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';

class CastServiceImpl {
  static Future<bool> openCastSettings() async {
    if (!Platform.isAndroid) return false;

    Future<bool> tryLaunch(String action) async {
      try {
        final intent = AndroidIntent(action: action);
        await intent.launch();
        return true;
      } catch (_) {
        return false;
      }
    }

    if (await tryLaunch('android.settings.CAST_SETTINGS')) return true;
    // Some devices don't implement CAST_SETTINGS, fall back to general settings.
    if (await tryLaunch('android.settings.SETTINGS')) return true;
    // Last resort: WiFi settings.
    return await tryLaunch('android.settings.WIFI_SETTINGS');
  }
}
