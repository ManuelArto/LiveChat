import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';

import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/models/message.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import '../constants.dart';

class SocketProvider with ChangeNotifier {
  Auth auth;
  Map<String, List<Message>> _messages = {"GLOBAL": []};
  SocketIO _socketIO;

  void init() {
    _socketIO = SocketIOManager().createSocketIO(URL_SOCKETIO, "/socketio", query: "token=${auth.token}");
    _socketIO.subscribe('receive_message', receiveMessage);
    _socketIO.connect();
  }

  void receiveMessage(jsonData) {
    addMessage(jsonData["message"], jsonData["sender"], jsonData["receiver"]);
  }

  void sendMessage(String message, String receiver) {
    final data = json.encode({
      "token": auth.token,
      "message": message,
      "receiver": receiver,
    });
    _socketIO.sendMessage("send_message", data);
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