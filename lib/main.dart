import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_websocket_client/providers/connection_provider.dart';
import 'package:flutter_websocket_client/providers/counter_provider.dart';
import 'package:flutter_websocket_client/websocket/websocket_client.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Websocket App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Websocket App'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  late WebSocketClient socket;

  @override
  void initState() {
    super.initState();
    socket = WebSocketClient(ref, "ws://127.0.0.1:8042/gui", delay: 15);
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counterState = ref.watch(counterProvider);
    final connectionState = ref.watch(connectionProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 96.0),
              child: Text(
                connectionState.showDisconnect ? 'Disconnected' : 'Connected',
                style: TextStyle(fontSize: 18, color: connectionState.showDisconnect ? Colors.red : Colors.green),
              ),
            ),
            const Text('Click "manual" or "from server" to increment counter:'),
            Text(
              counterState.counter.toString(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => ref.read(counterProvider.notifier).incrementCounter(),
                child: const Text('Manual Increment'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: connectionState.showDisconnect
                    ? null
                    : () {
                        socket.sendMessage({
                          "type": SocketMessageType.incrementCounter,
                          "data": {"value": 1}
                        });
                      },
                child: const Text('Increment from server'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
