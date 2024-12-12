abstract class MessageManager {
  Stream<bool> get connectionStateStream;

  Stream<String> get incomingMessages;
  void sendMessage(Map<String, dynamic> message);
}
