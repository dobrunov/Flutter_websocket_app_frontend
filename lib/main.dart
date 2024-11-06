import 'package:flutter/material.dart';
import 'package:flutter_websocket_client/socket.dart';
import 'package:flutter_websocket_client/store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

void main() async {
  AppState appStore = AppState(); // Instantiate the store

  WebSocketClient socket = WebSocketClient(appStore, "ws://127.0.0.1:8042/gui", delay: 15);

  runApp(MultiProvider(providers: [
    Provider<AppState>(create: (_) => appStore),
    Provider<WebSocketClient>(create: (_) => socket),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
              'You have pushed the button this many times:',
            ),
            Observer(builder: (context) {
              return Text(
                store.main.counter.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          store.main.incrementCounter();
          socket.sendMessage({"type": "Test", "data": ""});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
