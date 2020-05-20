import 'package:LiveChatFrontend/widgets/auth/authForm.dart';
import 'package:LiveChatFrontend/widgets/gradient_background.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GradienBackGround(double.infinity),
          AuthForm(),
        ],
      ),
    );
  }
}
