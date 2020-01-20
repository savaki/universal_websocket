import 'package:universal_websocket/src/common.dart';

class WebSocket extends BaseWebSocket {
  WebSocket(
    String url,
    void Function(dynamic) onData, {
    void Function() onComplete = defaultComplete,
    void Function(void Function(dynamic) send) onConnect = defaultConnect,
    bool Function() onDisconnect = defaultDisconnect,
    void Function(Type t) onError = defaultError,
    Duration Function(Duration) backoff = exponential,
    bool verbose = false,
    Map<String, dynamic> headers,
  }) : super(url, onData,
            onComplete: onComplete,
            onConnect: onConnect,
            onDisconnect: onDisconnect,
            onError: onError,
            headers: headers,
            verbose: verbose,
            backoff: backoff) {
    if (verbose) {
      print('websocket:none');
    }
  }

  @override
  void connect() {}

  @override
  void dispose() {}
}
