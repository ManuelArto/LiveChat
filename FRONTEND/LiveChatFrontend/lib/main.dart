import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/screens/auth_screen.dart';
import 'package:LiveChatFrontend/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LiveChat',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.orange,
        ),
        home: Consumer<Auth>(
          builder: (context, auth, _) => auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : AuthScreen(),
                ),
        ),
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
      ),
    );
  }
}
