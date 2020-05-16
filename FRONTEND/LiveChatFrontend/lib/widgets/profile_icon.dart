import 'package:LiveChatFrontend/models/user.dart';
import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: user.username,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(right: 10.0),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 30.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  user.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.greenAccent[700],
              radius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
