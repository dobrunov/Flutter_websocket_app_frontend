import 'dart:convert';
import 'dart:developer';

import 'package:mobx/mobx.dart';
import '../message_manager/message_manager.dart';
import '../models/counter_model.dart';
import '../socket_messages/socket_messages_type.dart';

part 'app_state.g.dart';

class AppState = AppStoreBase with _$AppState;

abstract class AppStoreBase with Store {
  final MessageManager messageManager;

  AppStoreBase(this.messageManager) {
    _handleIncomingMessages();
  }

  @observable
  int counter = 0;

  void _handleIncomingMessages() {
    messageManager.incomingMessages.listen((message) {
      final decodedMessage = jsonDecode(message);

      switch (decodedMessage['type']) {
        case SocketMessagesType.updateCounter:
          updateCounter(decodedMessage['data']);
          break;
        default:
          log("[Unhandled message type]: ${decodedMessage['type']}");
      }
    });
  }

  @action
  void updateCounter(data) {
    final newCounter = Counter.fromJson(data);
    counter = counter + newCounter.value;
  }

  @action
  void incrementCounter() {
    counter++;
  }


  @action
  void incrementServerCounter(Map<String, String> message) {
    messageManager.sendMessage(message);
  }
}


