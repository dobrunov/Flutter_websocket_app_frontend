abstract class WebSocketClient {
  connect();
  disconnect();
  Stream<bool> get connectionStateStream;
  Stream<String> get messages;
  void sendMessage(Map<String, dynamic> message);
}
