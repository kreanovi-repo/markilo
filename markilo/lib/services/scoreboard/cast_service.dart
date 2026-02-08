import 'cast_service_stub.dart' if (dart.library.io) 'cast_service_io.dart';

/// Chromecast helper.
///
/// On Android we open the system Cast settings panel.
/// On other platforms this returns false.
class CastService {
  static Future<bool> openCastSettings() => CastServiceImpl.openCastSettings();
}
