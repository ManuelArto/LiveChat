import 'package:LiveChatFrontend/providers/socket_provider.dart';
import 'package:LiveChatFrontend/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final chatNames = Provider.of<SocketProvider>(context).chatNames;
    return ListView.builder(
      itemCount: chatNames.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ChatScreen.routeName, arguments: chatNames[index]),
          child: ListTile(
            leading: Icon(Icons.chat_bubble),
            title: Text(
              chatNames[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Last messages."),
            trailing: Text("00:00"),
          ),
        ),
      ),
    );
  }
}
