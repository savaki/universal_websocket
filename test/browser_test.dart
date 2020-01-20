import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:universal_websocket/websocket.dart';

void main() {
  test('adds one to input values', () {
    final webSocket = WebSocket(
        'wss://echo.websocket.org', (data) => print(data),
        verbose: true);

    for (var i = 0; i < 15; i += 1) {
      new Timer(Duration(seconds: 1), ()=>print('tick'));
      print('tick');
    }

    webSocket.dispose();
  });
}
