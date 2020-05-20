import 'package:LiveChatFrontend/providers/socket_provider.dart';
import 'package:LiveChatFrontend/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chats = Provider.of<SocketProvider>(context).chats;
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ChatScreen.routeName,
            arguments: chats[index]["chatName"],
          ),
          child: ListTile(
            leading: Icon(Icons.chat_bubble),
            title: Text(
              chats[index]["chatName"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chats[index]["lastMessage"]),
            trailing: Text(chats[index]["time"]),
          ),
        ),
      ),
    );
  }
}
