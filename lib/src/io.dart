import 'dart:async';
import 'dart:io' as io;

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
    Duration timeLimit = const Duration(seconds: 15),
    Map<String, dynamic> headers,
  }) : super(url, onData,
            onComplete: onComplete,
            onConnect: onConnect,
            onDisconnect: onDisconnect,
            onError: onError,
            headers: headers,
            verbose: verbose,
            timeLimit: timeLimit,
            backoff: backoff) {
    if (verbose) {
      print('websocket:io');
    }
  }

  Duration _delay;
  io.WebSocket _webSocket;
  bool _disposed = false;

  void _handleComplete() {}

  void _handleConnect(io.WebSocket webSocket) {
    if (verbose) {
      print('websocket:connected');
    }

    _delay = null;
    _webSocket = webSocket;
    this.onConnect(webSocket.add);

    webSocket
        .listen((event) => onData(event),
            onError: (error) => onError(error.runtimeType), cancelOnError: true)
        .asFuture()
        .then((_) => _handleDisconnect());
  }

  void _handleDisconnect() {
    if (this._disposed) {
      return;
    }

    _delay = backoff(_delay);
    print('disconnected.  next attempt in $_delay');
    new Timer(_delay, connect);
  }

  void _handleError(dynamic error) {
    _delay = backoff(_delay);
    print('error $error.  next attempt in $_delay');
    new Timer(_delay, connect);
  }

  @override
  void connect() {
    if (verbose) {
      print('websocket:connecting to $url');
    }

    io.WebSocket.connect(url, headers: headers)
        .timeout(timeLimit)
        .then(_handleConnect)
        .catchError(_handleError)
        .whenComplete(_handleComplete);
  }

  @override
  void dispose() {
    print('disposed called');
    this._disposed = false;
    if (this._webSocket != null) {
      this._webSocket.close();
      if (verbose) {
        print('websocket:disposed');
      }
    }
  }
}
