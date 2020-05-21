import 'dart:async';
import 'dart:convert';

import 'package:LiveChatFrontend/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Auth with ChangeNotifier {
  String _token;
  String refreshToken;
  DateTime _expToken;
  DateTime _expRefreshToken;
  String _userId;
  String _username;
  String imageUrl;
  Function disconncect;
  Timer _timer;

  String get username => _username;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expToken != null && _expRefreshToken.isAfter(DateTime.now())) {
      if (_expToken.isBefore(DateTime.now())) _getNewToken();
      return _token ?? null;
    }
  }

  set token(String newToken) => _token = newToken;

  String get userId {
    return _userId;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) return false;
    final userData = json.decode(prefs.getString("userData"));
    _expToken = DateTime.parse(userData["expInToken"]);
    _expRefreshToken = DateTime.parse(userData["expInToken"]);
    _userId = userData["userId"];
    _token = userData["token"];
    refreshToken = userData["refreshToken"];
    _username = userData["username"];
    imageUrl = userData["imageUrl"];
    if (!isAuth) return false;
    _autoRefresh();
    notifyListeners();
    return true;
  }

  Future<void> signup(
      String email, String username, String password, String image) async {
    return _authenticate(
      {
        "username": username,
        "email": email,
        "password": password,
        "imageFile": image
      },
      URL_AUTH_SIGNUP,
    );
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(
      {"email": email, "password": password},
      URL_AUTH_SIGNIN,
    );
  }

  Future<void> _authenticate(Map<String, dynamic> body, String url) async {
      final response = await http.post(
        url,
        body: json.encode(body),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData.containsKey("error"))
        throw HttpException(responseData["error"]);
      saveData(responseData);
  }

  Future<void> _getNewToken() async {
    print("GETTING NEW TOKEN");
    while (true) {
      try {
        final response = await http.post(URL_AUTH_REFRESH_TOKEN,
            headers: {"x-access-tokens": refreshToken});
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData.containsKey("error")) {
          logout();
          break;
        }
        saveData(responseData);
        break;
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    refreshToken = null;
    _username = null;
    _expRefreshToken = null;
    _expToken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _timer.cancel();
    disconncect();
    notifyListeners();
  }

  void saveData(Map<String, dynamic> responseData) {
    _token = responseData["token"];
    refreshToken = responseData["refreshToken"];
    _username = responseData["username"];
    _userId = responseData["uid"];
    imageUrl = responseData["imageUrl"];
    _expToken =
        DateTime.now().add(Duration(seconds: responseData["expInToken"]));
    _expRefreshToken = DateTime.now()
        .add(Duration(seconds: responseData["expInRefreshToken"]));
    _autoRefresh();
    storeValues();
    notifyListeners();
  }

  Future<void> storeValues() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "token": _token,
      "refreshToken": refreshToken,
      "userId": _userId,
      "username": _username,
      "expInRefreshToken": _expRefreshToken.toIso8601String(),
      "expInToken": _expToken.toIso8601String(),
      "imageUrl": imageUrl,
    });
    prefs.setString("userData", userData);
  }

  void _autoRefresh() {
    final timeToRefresh = _expToken.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: timeToRefresh), _getNewToken);
  }

  // void _autoLogout() {
  //   final timeToLogout = _expRefreshToken.inSeconds;
  //   Timer(Duration(seconds: timeToLogout), logout);
  // }
}
