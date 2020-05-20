import 'package:LiveChatFrontend/providers/socket_provider.dart';
import 'package:LiveChatFrontend/widgets/messages/messages.dart';
import 'package:LiveChatFrontend/widgets/messages/new_message.dart';
import 'package:LiveChatFrontend/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chatScreen";
  final String chatName;

  ChatScreen(this.chatName);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    final user = socketProvider.getUser(widget.chatName);
    socketProvider.currentChat = widget.chatName;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.6),
        title: Text(
          widget.chatName,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Messages(widget.chatName),
            ),
          ),
          NewMessage(widget.chatName),
        ],
      ),
    );
  }
}
