abstract class WebSocketClient {
  connect();
  disconnect();
  Stream<String> get messages;
  void sendMessage(Map<String, dynamic> message);
}
