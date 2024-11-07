import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_websocket_client/store/store.dart';
import 'package:flutter_websocket_client/websocket/websocket_client.dart';
import 'package:provider/provider.dart';

void main() async {
  AppState appStore = AppState();

  WebSocketClient socket = WebSocketClient(appStore, "ws://127.0.0.1:8042", delay: 15);

  runApp(MultiProvider(providers: [
    Provider<AppState>(create: (_) => appStore),
    Provider<WebSocketClient>(create: (_) => socket),
  ], child: const MyApp()));
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AppState store;
  late WebSocketClient socket;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    store = Provider.of<AppState>(context);
    socket = Provider.of<WebSocketClient>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Click "manual" or "from server" to increment counter:',
            ),
            Observer(builder: (context) {
              return Text(
                store.home.counter.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              );
            }),
            ElevatedButton(
                onPressed: () {
                  store.home.incrementCounter();
                },
                child: const Text('Manual Increment')),
            ElevatedButton(
                onPressed: () {
                  socket.sendMessage({"type": SocketMessageType.incrementCounter, "data": "1"});
                },
                child: const Text('Increment from server'))
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
