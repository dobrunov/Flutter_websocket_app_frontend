import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_websocket_client/websocket/websocket_client.dart';

import '../providers/counter_provider.dart';

class MessageController {
  final WebSocketClient client;
  final WidgetRef ref;

  MessageController(this.client, this.ref) {
    client.messages.listen((message) {
      final jsonData = jsonDecode(message);
      _handleMessage(jsonData);
    });
  }

  void _handleMessage(Map<String, dynamic> jsonData) {
    switch (jsonData['type']) {
      case SocketMessageType.updateCounter:
        ref.read(counterProvider.notifier).updateCounter(jsonData['data']);
        break;
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    client.sendMessage(message);
  }

  void dispose() {
    client.dispose();
  }
}

class SocketMessageType {
  static const updateCounter = "UpdateCounter";
  static const incrementCounter = "IncrementCounter";
}
