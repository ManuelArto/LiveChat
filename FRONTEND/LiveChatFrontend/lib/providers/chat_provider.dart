import 'package:LiveChatFrontend/models/message.dart';
import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  Map<String, List<Message>> _messages = {
    "GLOBAL" : []
  };

  List<Message> messages(String chatName) => _messages[chatName];

  List<String> get chatNames => _messages.keys.toList();

  void addMessage(String message, String sender, String chatName) {
    _messages[chatName]
        .add(Message(content: message, sender: sender, time: DateTime.now()));
    notifyListeners();
  }
}
