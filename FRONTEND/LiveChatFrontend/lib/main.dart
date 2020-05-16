import 'package:LiveChatFrontend/screens/auth_screen.dart';
import 'package:LiveChatFrontend/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LiveChat',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.orange,
      ),
      home: HomeScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomeScreen.routeName:
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case AuthScreen.routeName:
            return MaterialPageRoute(builder: (context) => AuthScreen());
          case ChatScreen.routeName:
            return MaterialPageRoute(
              builder: (context) => ChatScreen(settings.arguments),
            );
        }
      },
    );
  }
}
