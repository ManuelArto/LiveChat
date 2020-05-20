import 'package:LiveChatFrontend/providers/socket_provider.dart';
import 'package:LiveChatFrontend/screens/chat_screen.dart';
import 'package:LiveChatFrontend/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveUsers extends StatelessWidget {
  final screenSize;

  ActiveUsers(this.screenSize);

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    final activeUsers = socketProvider.onlineUsers;
    return Container(
      margin: const EdgeInsets.only(left: 30.0, top: 5),
      height: screenSize.height * 0.12,
      alignment: Alignment.centerLeft,
      child: activeUsers.length == 0
          ? Text(
              "No active users",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: activeUsers.length,
              itemBuilder: (context, index) {
                final user = activeUsers[index];
                return GestureDetector(
                  onTap: () {
                    socketProvider.readChat(user.username);
                    Navigator.of(context)
                        .pushNamed(ChatScreen.routeName,
                            arguments: user.username)
                        .then((_) => socketProvider.currentChat = "");
                  },
                  child: ProfileIcon(user: user),
                );
              },
            ),
    );
  }
}
