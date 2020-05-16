import 'package:LiveChatFrontend/models/users.dart';
import 'package:LiveChatFrontend/widgets/messages/messages.dart';
import 'package:LiveChatFrontend/widgets/messages/new_message.dart';
import 'package:LiveChatFrontend/widgets/profile_icon.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = "/chatScreen";
  final String chatName;

  ChatScreen(this.chatName);

  @override
  Widget build(BuildContext context) {
    final index = Users.users.indexWhere((user) => user.username == chatName);
    final user = index != -1 ? Users.users[index] : null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.6),
        title: Container(
            alignment: Alignment.center,
            child: Text(
              chatName,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: user == null ? null : ProfileIcon(user: user),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Messages(chatName),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
