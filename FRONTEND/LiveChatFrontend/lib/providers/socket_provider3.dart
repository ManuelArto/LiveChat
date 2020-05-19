import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/models/message.dart';
import '../constants.dart';

class SocketProvider with ChangeNotifier {
  Auth auth;
  Map<String, List<Message>> _messages = {"GLOBAL": []};
  SocketIOManager _manager;
  SocketIO _socketIO;

  void init() async{
    _manager = SocketIOManager();
    _socketIO = await _manager.createInstance(SocketOptions(
      URL_SOCKETIO,
      nameSpace: "/socketio",
      query: {"token": auth.token},
      enableLogging: true,
      transports: [Transports.WEB_SOCKET, Transports.POLLING],
    ));

    _socketIO.on('receive_message', receiveMessage);
    _socketIO.connect();
  }

  void receiveMessage(jsonData) {
    jsonData = json.decode(jsonData);
    addMessage(jsonData["message"], jsonData["sender"], jsonData["receiver"]);
  }

  void sendMessage(String message, String receiver) async {
    final data = json.encode({
      "token": auth.token,
      "message": message,
      "receiver": receiver,
    });
    _socketIO.emit("send_message", [data]);
    addMessage(message, auth.username, receiver);
  }

  void update(Auth auth) {
    this.auth = auth;
    if (_socketIO == null) {
      init();
    }
  }

  void destroy() async{
    _manager.clearInstance(_socketIO);
  }

  List<Message> messages(String chatName) => _messages[chatName];

  List<String> get chatNames => _messages.keys.toList();

  void addMessage(String message, String sender, String chatName) {
    _messages[chatName]
        .add(Message(content: message, sender: sender, time: DateTime.now()));
    notifyListeners();
  }
}
