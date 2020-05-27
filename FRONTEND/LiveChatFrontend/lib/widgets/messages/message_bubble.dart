import 'package:LiveChatFrontend/screens/chat_screen.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MessageBubble extends StatelessWidget {
  final String message, username, imageUrL;
  final DateTime time;
  final bool isMe;
  final Key key;

  MessageBubble(
      {this.message,
      this.username,
      this.imageUrL,
      this.isMe,
      this.key,
      this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5),
              decoration: BoxDecoration(
                color: isMe ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(20),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                    child: Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe ? Colors.black : Colors.grey[900],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            Positioned(
              top: -5,
              right: isMe ? null : -10,
              left: isMe ? -10: null,
              child: GestureDetector(
                onTap: isMe
                    ? () {}
                    : () => Navigator.of(context)
                        .pushReplacementNamed(ChatScreen.routeName, arguments: username),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrL),
                ),
              ),
            ),
          ],
          overflow: Overflow.visible,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(DateFormat("jm").format(time)),
        ),
      ],
    );
  }
}
