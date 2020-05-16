import 'package:LiveChatFrontend/models/user.dart';

class Users {
  static List<User> _users = [
    User("manuelarto", "assets/images/profile_icon.jpg", true),
    User("pino", "assets/images/profile_icon.jpg", true),
    User("gigialessio", "assets/images/profile_icon.jpg", true),
    User("mariorossi", "assets/images/profile_icon.jpg", true),
    User("andreanapoli", "assets/images/profile_icon.jpg", true),
    User("lucaguidoni", "assets/images/profile_icon.jpg", true),
    User("francoalberti", "assets/images/profile_icon.jpg", true),
    User("eugeniomontale", "assets/images/profile_icon.jpg", true),
    User("ottaviano", "assets/images/profile_icon.jpg", true),
    User("ernesto", "assets/images/profile_icon.jpg", true),
    User("pinkguy", "assets/images/profile_icon.jpg", true),
    User("nancyarcodia", "assets/images/profile_icon.jpg", true),
  ];

  static List<User> get users => List.from(_users);
}