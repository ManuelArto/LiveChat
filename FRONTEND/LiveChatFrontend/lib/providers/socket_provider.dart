import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/models/message.dart';
import '../constants.dart';

class SocketProvider with ChangeNotifier {
  Auth auth;
  Map<String, List<Message>> _messages = {"GLOBAL": []};
  Socket _socketIO;

  void init() {
    _socketIO = io('$URL_SOCKETIO/socketio', <String, dynamic>{
      'transports': ['websocket'],
      'query': "token=${auth.token}" // optional
    });
    _socketIO.on("connect", (_) => print('Connected'));
    _socketIO.on("disconnect", (_) => print('Disconnected'));
    _socketIO.on('receive_message', receiveMessage);
  }

  void receiveMessage(jsonData) {
    addMessage(jsonData["message"], jsonData["sender"], jsonData["receiver"]);
  }

  void sendMessage(String message, String receiver) {
    print("sending");
    final data = json.encode({
      "token": auth.token,
      "message": message,
      "receiver": receiver,
    });
    _socketIO.emit("send_message", data);
    addMessage(message, auth.username, receiver);
  }

  void update(Auth auth) {
    this.auth = auth;
    if (_socketIO == null) {
      init();
    }
  }

  void destroy() {
    _socketIO.destroy();
  }

  List<Message> messages(String chatName) => _messages[chatName];

  List<String> get chatNames => _messages.keys.toList();

  void addMessage(String message, String sender, String chatName) {
    _messages[chatName]
        .add(Message(content: message, sender: sender, time: DateTime.now()));
    notifyListeners();
  }

}
