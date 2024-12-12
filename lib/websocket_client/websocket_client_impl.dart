import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_websocket_client/websocket_client/websocket_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class WebSocketClientImpl implements WebSocketClient {
  final String url;
  final int delay;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  WebSocketChannel? _channel;
  final _controller = StreamController<String>.broadcast();
  final StreamController<bool> _connectionStateController = StreamController<bool>.broadcast();

  void _updateConnectionState(bool newState) => _connectionStateController.add(newState);



  WebSocketClientImpl(this.url, {this.delay = 5}) {
    _updateConnectionState(true);
    connect();
  }

  @override
  Stream<bool> get connectionStateStream => _connectionStateController.stream;

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
    _updateConnectionState(true);
    log("[Incoming message]: $event");
    _controller.add(event);
  }

  void _onConnectionError(Object error) {
    _updateConnectionState(false);
    log('[WebSocket Error]: $error');
    _controller.addError(error);
    _handleReconnect();
  }

  void _onConnectionDone() {
    _updateConnectionState(false);
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
