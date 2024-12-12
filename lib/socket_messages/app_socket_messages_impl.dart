import 'dart:developer';

import 'package:flutter_websocket_client/socket_messages/app_socket_messages.dart';
import 'package:flutter_websocket_client/socket_messages/socket_messages_type.dart';
import '../state/app_state.dart';

class AppSocketMessagesImpl implements AppSocketMessages {
  final AppState appState;

  AppSocketMessagesImpl(this.appState);

  @override
  void manualIncrement() {
    appState.incrementCounter();
  }

  @override
  void incrementFromServer() {
    log(appState.counter.toString(), name: "Counter");
    var message = {
      "type": SocketMessagesType.incrementCounter,
      "data": "1",
    };
    appState.incrementServerCounter(message);
  }


}
