import 'dart:convert';

import 'package:LiveChatFrontend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/models/message.dart';
import '../constants.dart';

class SocketProvider with ChangeNotifier {
  Socket _socketIO;
  Auth auth;
  Map<String, User> _users;
  Map<String, List<Message>> _messages;

  SocketProvider() {
    _users = {};
    _messages = {"GLOBAL": []};
  }

  void init() {
    _socketIO = io('$URL_SOCKETIO/socketio', <String, dynamic>{
      'transports': ['websocket', "polling"],
      'query': "token=${auth.token}"
    });
    _initListener();
  }

  void _initListener() {
    _socketIO.on("connect", (_) => print('Connected'));
    _socketIO.on("disconnect", (_) => print('Disconnected'));
    _socketIO.on('receive_message', _receiveMessage);
    _socketIO.on("user_connected", _userConnected);
    _socketIO.on("user_disconnecred", _userDisconnected);
  }

  void _receiveMessage(jsonData) {
    print("RECEIVED MESSAGE $jsonData");
    addMessage(
      jsonData["message"],
      jsonData["sender"],
      auth.username == jsonData["receiver"]
          ? jsonData["sender"]
          : jsonData["receiver"],
    );
  }

  void _userConnected(jsonData) {
    print("UPDATE USERS CONNECTED");
    jsonData.forEach((username, data) {
      if (username != auth.username) {
        if (!_users.containsKey(username)) {
          _users[username] = User(
            username: username,
            imageUrl: data["imageUrl"],
            isOnline: true,
          );
          _messages[username] = [];
        } else
          _users[username].isOnline = true;
      }
    });
    notifyListeners();
  }

  void _userDisconnected(jsonData) {
    print("${jsonData['username']} DISCONNECTED");
    _users[jsonData["username"]].isOnline = false;
    notifyListeners();
  }

  void sendMessage(String message, String receiver) {
    print("Sending $message to $receiver");
    final data = json.encode({
      "token": auth.token,
      "message": message,
      "receiver": receiver,
    });
    _socketIO.emit("send_message", data);
    addMessage(message, auth.username, receiver);
  }

  void destroy() {
    print("Destroying");
    _socketIO.destroy();
    SocketProvider();
  }

  void update(Auth auth) {
    this.auth = auth;
    auth.disconncect = destroy;
  }

  // Messages

  List<Message> messages(String chatName) => _messages[chatName];

  List<String> get chatNames => _messages.keys.toList();

  void addMessage(String message, String sender, String chatName) {
    _messages[chatName]
        .add(Message(content: message, sender: sender, time: DateTime.now()));
    notifyListeners();
  }

  // Users

  List<User> get onlineUsers =>
      _users.values.where((user) => user.isOnline).toList();

  User getUser(String name) {
    return _users[name];
  }
}
