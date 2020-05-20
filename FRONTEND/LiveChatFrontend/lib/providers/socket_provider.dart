import 'dart:convert';

import 'package:LiveChatFrontend/helpers/db_helper.dart';
import 'package:LiveChatFrontend/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/models/message.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';

class SocketProvider with ChangeNotifier {
  Socket _socketIO;
  Auth auth;
  Map<String, User> _users = {};
  Map<String, Map<String, dynamic>> _messages = {
    "GLOBAL": {"toRead": 0, "list": []}
  };

  Future<void> init() async {
    print("INIT");
    if (!identical(0.0, 0)) await getFromMemory();
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
          storeInMemory("USERS", _users[username].toJson());
          _messages[username] = {"toRead": 0, "list": []};
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

  // persistentData

  Future<void> getFromMemory() async {
    print("FETCHING FROM MEMORY");
    final usersList = await DBHelper.getData(auth.userId, "USERS");
    usersList.forEach((data) {
      _users[data["username"]] = User.fromJson(data);
    });
    final messagesList = await DBHelper.getData(auth.userId, "MESSAGES");
    messagesList.forEach((data) {
      if (!_messages.containsKey(data["chatName"]))
        _messages[data["chatName"]] = {"toRead": 0, "list": []};
      _messages[data["chatName"]]["list"].add(Message.fromJson(data));
    });
  }

  Future<void> storeInMemory(String table, Map<String, dynamic> data) async {
    print("STORING $data in $table");
    DBHelper.insert(auth.userId, table, data);
  }

  // Messages

  List<dynamic> messages(String chatName) => _messages[chatName]["list"];

  void readChat(String chatName) {
    _messages[chatName]["toRead"] = 0;
    notifyListeners();
  }

  List<Map<String, dynamic>> get chats {
    final List<Map<String, dynamic>> chats = [];
    _messages.forEach((chatName, data) {
      if (data["list"].length == 0) {
        chats.add({
          "chatName": chatName,
          "lastMessage": "No message",
          "time": "",
          "toRead": data["toRead"].toString(),
        });
      } else {
        chats.add({
          "chatName": chatName,
          "lastMessage": getUser(chatName) == null
              ? "${data['list'].last.sender}: ${data["list"].last.content}"
              : data["list"].last.content,
          "time": DateFormat("jm").format(data["list"].last.time),
          "toRead": data["toRead"].toString(),
        });
      }
    });
    return chats;
  }

  void addMessage(String message, String sender, String chatName) {
    Message newMessage = Message(
      content: message,
      sender: sender,
      time: DateTime.now(),
      id: Uuid().v1(),
      chatName: chatName,
    );
    _messages[chatName]["list"].add(newMessage);
    _messages[chatName]["toRead"] += 1;
    notifyListeners();
    storeInMemory("MESSAGES", newMessage.toJson());
  }

  // Users

  List<User> get onlineUsers =>
      _users.values.where((user) => user.isOnline).toList();

  User getUser(String username) {
    return _users[username];
  }

  String getImageUrl(String username) {
    return _users[username]?.imageUrl ?? "assets/images/profile_icon.jpg";
  }

  bool userIsOnline(String username) {
    return _users[username].isOnline;
  }
}
