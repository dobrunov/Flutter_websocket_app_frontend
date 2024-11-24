import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_websocket_client/store/app_state.dart';
import 'package:flutter_websocket_client/websocket_client/websocket_client_impl.dart';
import 'package:provider/provider.dart';

import 'message_manager/message_manager_impl.dart';

void main() {
  final webSocketClient = WebSocketClientImpl("ws://127.0.0.1:8042");
  final messageManager = MessageManagerImpl(webSocketClient);
  final appStore = AppState(messageManager);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppState>(create: (_) => appStore),
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

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late AppState appStore;

  @override
  void didChangeDependencies() {
    appStore = context.watch<AppState>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Click "manual" or "from server" to increment counter:'),
            Observer(builder: (context) {
              return Text(
                appStore.counter.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              );
            }),
            ElevatedButton(
              onPressed: () => appStore.incrementCounter(),
              child: const Text('Manual Increment'),
            ),
            ElevatedButton(
              onPressed: () => appStore.incrementServerCounter(),
              child: const Text('Increment from server'),
            ),
          ],
        ),
      ),
    );
  }
}
