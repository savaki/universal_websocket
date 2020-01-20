import 'dart:async';
import 'dart:html' as html;

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
      print('websocket:html');
    }
  }

  Duration _timeLimit;
  html.WebSocket _webSocket;
  bool _disposed = false;

  @override
  void connect() {
    if (verbose) {
      print('websocket:connecting to $url');
    }

    final webSocket = html.WebSocket(url);
    this._webSocket = webSocket;

    webSocket.onClose.listen((event) {
      if (verbose) {
        print('websocket:onClose');
      }
      final reconnect = onDisconnect();
      if (!this._disposed && reconnect) {
        new Timer(_timeLimit, () => connect());
      } else {
        onComplete();
      }
    });

    _timeLimit = backoff(_timeLimit);
    print('time limit is $_timeLimit');
    webSocket.onOpen.first.timeout(_timeLimit).then((event) {
      if (verbose) {
        print('websocket:onOpen');
      }
      onConnect(webSocket.send);
    });

    webSocket.onMessage.listen((event) {
      if (verbose) {
        print('websocket:onMessage(${event.data})');
      }
      onData(event.data);
    });

    webSocket.onError.listen((event) {
      if (verbose) {
        print('websocket:onError');
      }
      onError(event.runtimeType);
    });
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
