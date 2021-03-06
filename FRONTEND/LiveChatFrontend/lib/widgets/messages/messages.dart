import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/providers/socket_provider.dart';
import 'package:LiveChatFrontend/widgets/messages/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  final String chatName;

  Messages(this.chatName);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ScrollController _scrollController = ScrollController();
  String username;

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    username = Provider.of<Auth>(context, listen: false).username;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    final socketProvider = Provider.of<SocketProvider>(context);
    final messages = socketProvider.messages(widget.chatName);
    socketProvider.currentChat = widget.chatName;
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageBubble(
          username: message.sender,
          isMe: username == message.sender,
          key: ValueKey(message.id),
          message: message.content,
          imageUrL: socketProvider.getImageUrl(message.sender),
          time: message.time,
        );
      },
    );
  }
}
