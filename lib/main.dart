import 'package:flutter/material.dart';
import 'package:flutter_websocket_client/socket_messages/app_socket_messages.dart';
import 'package:flutter_websocket_client/socket_messages/app_socket_messages_impl.dart';
import 'package:flutter_websocket_client/state/app_state.dart';
import 'package:flutter_websocket_client/websocket_client/websocket_client_impl.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'message_manager/message_manager_impl.dart';

void main() {
  final webSocketClient = WebSocketClientImpl("ws://127.0.0.1:8042");
  final messageManager = MessageManagerImpl(webSocketClient);
  final appState = AppState(messageManager);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppState>(create: (_) => appState),
        Provider<AppSocketMessages>(create: (_) => AppSocketMessagesImpl(appState)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket App with MobX',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
