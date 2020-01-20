library websocket;

export 'src/none.dart'
    if (dart.library.io) 'src/io.dart'
    if (dart.library.html) 'src/html.dart';
