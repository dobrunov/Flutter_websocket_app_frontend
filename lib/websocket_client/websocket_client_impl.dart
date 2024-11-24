import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_websocket_client/websocket_client/websocket_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Incoming messages handling interface
// abstract class WebSocketEventHandler {
//   void onConnected();
//   void onDisconnected();
//   void onMessageReceived(Map<String, dynamic> message);
//   void onError(Object error);
// }

class WebSocketClientImpl implements WebSocketClient {
  final String url;
  final int delay;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  WebSocketChannel? _channel;
  final _controller = StreamController<String>.broadcast();

  WebSocketClientImpl(this.url, {this.delay = 5}) {
    connect();
  }

  @override
  connect() {
    disconnect();
    //
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel?.stream.listen(
      (event) => _handleMessage(event),
      onError: (error) => _onConnectionError(error),
      onDone: _onConnectionDone,
    );
  }

  void _handleMessage(dynamic event) {
    log("[Incoming message]: $event");
    _controller.add(event);
  }

  void _onConnectionError(Object error) {
    log('[WebSocket Error]: $error');
    _controller.addError(error);
    _handleReconnect();
  }

  void _onConnectionDone() {
    log('[WebSocket Disconnected]');
    _controller.close();
    _handleReconnect();
  }

  void _handleReconnect() async {
    if (_reconnectAttempts < maxReconnectAttempts) {
      _reconnectAttempts++;
      await Future.delayed(Duration(seconds: delay));
      connect();
    } else {
      log('[Reconnect failed after $maxReconnectAttempts attempts]');
    }
  }

  @override
  disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  @override
  Stream<String> get messages => _controller.stream;

  @override
  void sendMessage(Map<String, dynamic> message) {
    final messageJson = jsonEncode(message);
    log("[Sending message]: $messageJson");
    _channel?.sink.add(messageJson);
  }
}

//   void dispose() {
//     _webSocketChannel?.sink.close();
//     _webSocketChannel = null;
//   }
// }
