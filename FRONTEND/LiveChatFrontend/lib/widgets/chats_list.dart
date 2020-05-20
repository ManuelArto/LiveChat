import 'package:LiveChatFrontend/providers/socket_provider.dart';
import 'package:LiveChatFrontend/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    final chats = socketProvider.chats;
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () {
            socketProvider.readChat(chats[index]["chatName"]);
            Navigator.of(context).pushNamed(
              ChatScreen.routeName,
              arguments: chats[index]["chatName"],
            );
          },
          child: ListTile(
            leading: Stack(
              children: [
                Icon(Icons.chat_bubble),
                Positioned(
                  top: -10,
                  left: -10,
                  child: CircleAvatar(
                    maxRadius: 10.0,
                    backgroundColor: Theme.of(context).accentColor,
                    child: Text(
                      chats[index]["toRead"],
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
              overflow: Overflow.visible,
            ),
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
