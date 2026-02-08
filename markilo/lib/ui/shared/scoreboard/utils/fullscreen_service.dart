export 'fullscreen_service_stub.dart'
    if (dart.library.html) 'fullscreen_service_web.dart'
    if (dart.library.io) 'fullscreen_service_io.dart';
