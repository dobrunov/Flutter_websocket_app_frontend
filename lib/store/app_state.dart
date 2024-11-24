import 'dart:convert';
import 'dart:developer';

import 'package:mobx/mobx.dart';
import '../message_manager/message_manager.dart';
import '../models/counter_model.dart';

part 'app_state.g.dart';

class AppState = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  final MessageManager messageManager;

  AppStoreBase(this.messageManager) {
    _handleIncomingMessages();
  }

  @observable
  ObservableList<String> messages = ObservableList<String>();

  @observable
  int counter = 0;

  void _handleIncomingMessages() {
    messageManager.incomingMessages.listen((message) {
      messages.add(message);

      final decodedMessage = jsonDecode(message);
      final type = decodedMessage['type'];

      switch (type) {
        case SocketMessageType.updateCounter:
          final newCounter = Counter.fromJson(decodedMessage['data']);
          log(newCounter.value.toString());
          //
          updateCounter(newCounter.value);
          break;
        default:
          log("[Unhandled message type]: $type");
      }
    });
  }

  @action
  void updateCounter(int newValue) {
    counter = counter + newValue;
  }

  @action
  void incrementCounter() {
    counter++;
  }

  @action
  void sendMessage(Map<String, dynamic> message) {
    messageManager.sendMessage(message);
  }

  @action
  void incrementServerCounter() {
    var message = {
      "type": SocketMessageType.incrementCounter,
      "data": "1",
    };
    messageManager.sendMessage(message);
  }
}

class SocketMessageType {
  static const updateCounter = "UpdateCounter";
  static const incrementCounter = "IncrementCounter";
}
