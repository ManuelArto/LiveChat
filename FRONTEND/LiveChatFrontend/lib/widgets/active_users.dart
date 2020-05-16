import 'package:LiveChatFrontend/models/users.dart';
import 'package:LiveChatFrontend/screens/chat_screen.dart';
import 'package:LiveChatFrontend/widgets/profile_icon.dart';
import 'package:flutter/material.dart';

class ActiveUsers extends StatelessWidget {
  final screenSize;

  ActiveUsers(this.screenSize);

  @override
  Widget build(BuildContext context) {
    final activeUsers = Users.users.where((user) => user.isOnline).toList();
    return Container(
      margin: const EdgeInsets.only(left: 30.0, top: 5),
      height: screenSize.height * 0.12,
      alignment: Alignment.centerLeft,
      child: activeUsers.length == 0
          ? Text("No active users", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: activeUsers.length,
              itemBuilder: (context, index) {
                final user = activeUsers[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      ChatScreen.routeName,
                      arguments: user.username),
                  child: ProfileIcon(user: user),
                );
              },
            ),
    );
  }
}
