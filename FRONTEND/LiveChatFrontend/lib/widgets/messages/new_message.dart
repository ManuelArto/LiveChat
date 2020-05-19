import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMessage extends StatefulWidget {
  final String chatName;

  NewMessage(this.chatName);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  SocketProvider chatProvider;
  String username;

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<SocketProvider>(context, listen: false);
    username = Provider.of<Auth>(context, listen: false).username;
  }

  void _sendMessage() {
    chatProvider.sendMessage(_controller.text, widget.chatName);
    setState(() => _controller.text = "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(40.0)),
      child: ListTile(
        title: TextField(
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          enableSuggestions: true,
          controller: _controller,
          decoration: InputDecoration(labelText: "Type a message..."),
          onChanged: (value) => setState(() {}),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Theme.of(context).accentColor,
          ),
          child: IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: _controller.text.trim().isEmpty ? null : _sendMessage,
          ),
        ),
      ),
    );
  }
}
