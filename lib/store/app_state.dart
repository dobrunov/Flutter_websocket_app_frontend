import 'package:mobx/mobx.dart';

import '../websocket/websocket_client.dart';
import 'home_store.dart';

part 'app_state.g.dart';

class AppState = AppStateBase with _$AppState;

abstract class AppStateBase with Store implements WebSocketEventHandler {
  @observable
  HomePage home = HomePage();

  @override
  void onConnected() {
    home.updateConnectedState(true);
  }

  @override
  void onDisconnected() {
    home.updateConnectedState(false);
  }

  @override
  void onMessageReceived(Map<String, dynamic> message) {
    if (message['type'] == SocketMessageType.updateCounter) {
      home.updateCounter(message['data']);
    }
  }

  @override
  void onError(Object error) {
    home.updateConnectedState(false);
  }
}

class SocketMessageType {
  static const updateCounter = "UpdateCounter";
  static const incrementCounter = "IncrementCounter";
}
