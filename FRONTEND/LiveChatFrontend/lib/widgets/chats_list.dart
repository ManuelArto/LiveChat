import 'package:LiveChatFrontend/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatsList extends StatelessWidget {
  final List<String> chatsName;

  ChatsList(this.chatsName);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatsName.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ChatScreen.routeName, arguments: chatsName[index]),
          child: ListTile(
            leading: Icon(Icons.chat_bubble),
            title: Text(
              chatsName[index],
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
