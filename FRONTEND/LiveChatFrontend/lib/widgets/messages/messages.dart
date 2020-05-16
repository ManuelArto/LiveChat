import 'package:LiveChatFrontend/widgets/messages/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:LiveChatFrontend/models/chats.dart';

class Messages extends StatelessWidget {
  final String chatName;

  Messages(this.chatName);

  @override
  Widget build(BuildContext context) {
    final messages = Chats.getMessages(chatName);
    return ListView.builder(
      reverse: true,
      itemCount: messages?.length ?? 0,
      itemBuilder: (context, index) => MessageBubble(
        username: messages[index].sender,
        isMe: false,
        key: GlobalKey(),
        message: messages[index].content,
        imageUrL: messages[index].imageUrl,
        time: messages[index].time,
      ),
    );
  }
}
