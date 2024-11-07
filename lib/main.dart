import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_websocket_client/provider/counter_provider.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Click "manual" or "from server" to increment counter:'),
            Text(
              counterState.counter.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).incrementCounter(),
              child: const Text('Manual Increment'),
            ),
            ElevatedButton(
              onPressed: () => socket.sendMessage({
                "type": SocketMessageType.incrementCounter,
                "data": {"value": 1}
              }),
              child: const Text('Increment from server'),
            ),
          ],
        ),
      ),
    );
  }
}
