import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_websocket_client/store.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final String uri;
  final int delay;
  final AppState store;
  WebSocketChannel? _webSocketChannel;
  int _reconnectAttempts = 0;
  final int maxReconnectAttempts = 5;

  WebSocketClient(this.store, this.uri, {this.delay = 5}) {
    _connect();
  }

  // // Getter for stream
  // Stream<dynamic> get stream => _webSocketChannel!.stream;

  void _connect() {
    _webSocketChannel?.sink.close();

    _webSocketChannel = WebSocketChannel.connect(
      Uri.parse(uri),
      protocols: {"websocket"},
    );

    store.main.updateConnectedState(true);

    _webSocketChannel!.stream.listen(
      (event) {
        _reconnectAttempts = 0; // Reset reconnect attempts on successful message
        store.main.updateConnectedState(true);
        _handleMessage(event);
      },
      onError: (error) async {
        log('[WebSocket Error]: $error');
        store.main.updateConnectedState(false);
        _handleReconnect();
      },
      onDone: () async {
        log('[WebSocket Disconnected]');
        store.main.updateConnectedState(false);
        _handleReconnect();
      },
      cancelOnError: true,
    );
  }

  void _handleReconnect() async {
    if (_reconnectAttempts < maxReconnectAttempts) {
      _reconnectAttempts++;
      await Future.delayed(Duration(seconds: delay));
      _connect();
    } else {
      log('[Reconnect failed after $maxReconnectAttempts attempts]');
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    final messageJson = jsonEncode(message);
    log("Sending message: $messageJson");
    _webSocketChannel?.sink.add(messageJson);
  }

  void _handleMessage(String event) {
    log("[Incoming message]: $event");

    final Map<String, dynamic> jsonData = jsonDecode(event);

    switch (jsonData['type']) {
      case SocketMessageType.testOne:
        store.main.incrementCounter();
        break;

      case SocketMessageType.testTwo:
        store.main.updateTestTwo(jsonData['data']);
        break;
    }
  }

  void dispose() {
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
  }
}

class SocketMessageType {
  static const testOne = "TestOne";
  static const testTwo = "TestTwo";
}
