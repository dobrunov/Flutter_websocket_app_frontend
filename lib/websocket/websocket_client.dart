import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_websocket_client/provider/counter_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final String uri;
  final int delay;
  final WidgetRef ref;
  WebSocketChannel? _webSocketChannel;
  int _reconnectAttempts = 0;
  final int maxReconnectAttempts = 5;

  WebSocketClient(this.ref, this.uri, {this.delay = 5}) {
    // Delay the _connect method
    Future.microtask(() => _connect());
  }

  void _connect() {
    _webSocketChannel?.sink.close();
    _webSocketChannel = WebSocketChannel.connect(Uri.parse(uri), protocols: {"websocket"});

    ref.read(counterProvider.notifier).updateConnectedState(true);
    _webSocketChannel!.stream.listen(
      (event) {
        _reconnectAttempts = 0;
        ref.read(counterProvider.notifier).updateConnectedState(true);
        _handleMessage(event);
      },
      onError: (error) async {
        log('[WebSocket Error]: $error');
        ref.read(counterProvider.notifier).updateConnectedState(false);
        _handleReconnect();
      },
      onDone: () async {
        log('[WebSocket Disconnected]');
        ref.read(counterProvider.notifier).updateConnectedState(false);
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

  void _handleMessage(String event) {
    log("[Incoming message]: $event");
    final Map<String, dynamic> jsonData = jsonDecode(event);

    switch (jsonData['type']) {
      case SocketMessageType.updateCounter:
        ref.read(counterProvider.notifier).updateCounter(jsonData['data']);
        break;
    }
  }

  void dispose() {
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
  }
}

class SocketMessageType {
  static const updateCounter = "UpdateCounter";
  static const incrementCounter = "IncrementCounter";
}
