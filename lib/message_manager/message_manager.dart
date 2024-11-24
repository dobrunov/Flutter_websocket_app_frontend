abstract class MessageManager {
  Stream<String> get incomingMessages;
  void sendMessage(Map<String, dynamic> message);
}
