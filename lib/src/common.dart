import 'dart:async';

abstract class BaseWebSocket {
  final String url;
  final void Function(dynamic) onData;
  final void Function() onComplete;
  final void Function(void Function(dynamic) send) onConnect;
  final bool Function() onDisconnect;
  final void Function(Type t) onError;
  final Map<String, dynamic> headers;
  final bool verbose;
  final Duration Function(Duration) backoff;
  final Duration timeLimit;

  BaseWebSocket(
    this.url,
    this.onData, {
    this.onComplete = defaultComplete,
    this.onConnect = defaultConnect,
    this.onDisconnect = defaultDisconnect,
    this.onError = defaultError,
    this.backoff = exponential,
    this.verbose = false,
    this.timeLimit = const Duration(seconds: 15),
    this.headers,
  }) {
    Timer.run(() => this.connect());
  }

  void connect();

  void dispose();
}

Duration exponential(Duration d) {
  if (d == null) {
    return const Duration(milliseconds: 500);
  }

  if (d.inSeconds > 60) {
    return const Duration(seconds: 60);
  }

  return d * 2;
}

void defaultComplete() {}

void defaultConnect(void Function(dynamic) send) {}

bool defaultDisconnect() => true;

void defaultError(Type t) {}
