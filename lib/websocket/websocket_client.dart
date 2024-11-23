import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final String uri;
  final int delay;
  WebSocketChannel? _webSocketChannel;
  StreamController<String> _messageStreamController = StreamController.broadcast();
  Stream<String> get messages => _messageStreamController.stream;
  int _reconnectAttempts = 0;
  final int maxReconnectAttempts = 5;

  WebSocketClient(this.uri, {this.delay = 5}) {
    _connect();
  }

  void _connect() {
    _webSocketChannel?.sink.close();
    _webSocketChannel = WebSocketChannel.connect(Uri.parse(uri), protocols: {"websocket"});

    _webSocketChannel!.stream.listen(
      (event) {
        _reconnectAttempts = 0;
        log('[WebSocket Message]: $event');
        _messageStreamController.add(event);
      },
      onError: (error) async {
        log('[WebSocket Error]: $error');
        _handleReconnect();
      },
      onDone: () async {
        log('[WebSocket Disconnected]');
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
    log("[Sending message]: $messageJson");
    _webSocketChannel?.sink.add(messageJson);
  }

  void dispose() {
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
    _messageStreamController.close();
  }
}
