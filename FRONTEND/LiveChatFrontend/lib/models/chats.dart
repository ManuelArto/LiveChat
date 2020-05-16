import 'package:LiveChatFrontend/models/message.dart';

class Chats {
  static Map<String, List<Message>> _chats = {
    "manuelarto": [
      Message(content: "ciao fra", sender: "manuelarto", time: DateTime.now())
    ],
    "pino": [
      Message(content: "ciao fra", sender: "pino", time: DateTime.now())
    ],
    "lucaguidoni": [
      Message(content: "ciao fra", sender: "lucaguidoni", time: DateTime.now())
    ],
    "gigialessio": [
      Message(content: "ciao fra", sender: "gigialessio", time: DateTime.now())
    ],
    "GLOBAL": [
      Message(
          content: "ciao fra", sender: "andreanapoli", time: DateTime.now()),
      Message(content: "ciao fra", sender: "manuelarto", time: DateTime.now()),
      Message(content: "ciao fra", sender: "manuelarto", time: DateTime.now()),
      Message(content: "ciao fra", sender: "manuelarto", time: DateTime.now()),
      Message(content: "ciao fra", sender: "manuelarto", time: DateTime.now()),
      Message(content: "ciao fra", sender: "mariorossi", time: DateTime.now()),
      Message(content: "ciao fra", sender: "pinkguy", time: DateTime.now()),
      Message(content: "ciao fra", sender: "manuelarto", time: DateTime.now()),
      Message(content: "ciao fra", sender: "manuelarto", time: DateTime.now()),
      Message(
          content: "ciao fra", sender: "nancyarcodia", time: DateTime.now()),
      Message(content: "ciao fra", sender: "manuelarto", time: DateTime.now()),
      Message(content: "ciao fra", sender: "pinkguy", time: DateTime.now()),
      Message(content: "ciao fra", sender: "manuelarto", time: DateTime.now()),
    ]
  };

  static List<String> get chats => _chats.keys.toList();

  static List<Message> getMessages(String group) => _chats[group];
}
