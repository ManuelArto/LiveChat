import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/widgets/gradient_background.dart';
import 'package:flutter/material.dart';

import 'package:LiveChatFrontend/widgets/active_users.dart';
import 'package:LiveChatFrontend/widgets/home_messages_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GradienBackGround(MediaQuery.of(context).size.height * .7),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chat with\nfriends",
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.center,
                        icon: Icon(Icons.exit_to_app, size: 30),
                        onPressed: auth.logout,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                ActiveUsers(screenSize),
                MessagesList(screenSize: screenSize),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
