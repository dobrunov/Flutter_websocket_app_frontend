import '../websocket_client/websocket_client.dart';
import 'message_manager.dart';

class MessageManagerImpl implements MessageManager {
  final WebSocketClient _webSocketClient;

  MessageManagerImpl(this._webSocketClient);

  @override
  Stream<bool> get connectionStateStream => _webSocketClient.connectionStateStream;

  @override
  Stream<String> get incomingMessages => _webSocketClient.messages;

  @override
  sendMessage(Map<String, dynamic> message) => _webSocketClient.sendMessage(message);
}
