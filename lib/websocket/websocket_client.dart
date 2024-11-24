import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';

// Incoming messages handling interface
abstract class WebSocketEventHandler {
  void onConnected();
  void onDisconnected();
  void onMessageReceived(Map<String, dynamic> message);
  void onError(Object error);
}

class WebSocketClient {
  final String uri;
  final int delay;
  final WebSocketEventHandler handler;

  WebSocketChannel? _webSocketChannel;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;

  WebSocketClient(this.handler, this.uri, {this.delay = 5}) {
    _connect();
  }

  void _connect() {
    _webSocketChannel?.sink.close();
    _webSocketChannel = WebSocketChannel.connect(Uri.parse(uri));

    handler.onConnected();

    _webSocketChannel!.stream.listen(
      (event) => _handleMessage(event),
      onError: (error) => _onConnectionError(error),
      onDone: _onConnectionDone,
      cancelOnError: true,
    );
  }

  void _onConnectionError(Object error) {
    log('[WebSocket Error]: $error');
    handler.onError(error);
    _handleReconnect();
  }

  void _onConnectionDone() {
    log('[WebSocket Disconnected]');
    handler.onDisconnected();
    _handleReconnect();
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
    log("[Sending message]: $messageJson");
    _webSocketChannel?.sink.add(messageJson);
  }

  void _handleMessage(String event) {
    log("[Incoming message]: $event");

    final Map<String, dynamic> jsonData = jsonDecode(event);
    handler.onMessageReceived(jsonData);
  }

  void dispose() {
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
  }
}
