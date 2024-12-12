import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_websocket_client/socket_messages/app_socket_messages.dart';
import 'package:flutter_websocket_client/state/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late AppState appState;
  late AppSocketMessages appSocketMessages;

  @override
  void didChangeDependencies() {
    appState = context.watch<AppState>();
    appSocketMessages = context.watch<AppSocketMessages>();
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
                appState.counter.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              );
            }),
            ElevatedButton(
              onPressed: () => appSocketMessages.manualIncrement(),
              child: const Text('Manual Increment'),
            ),
            ElevatedButton(
              onPressed: () => appSocketMessages.incrementFromServer(),
              child: const Text('Increment from server'),
            ),
          ],
        ),
      ),
    );
  }
}
