import 'dart:async';
import 'dart:convert';

import 'package:LiveChatFrontend/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Auth with ChangeNotifier {
  String _token;
  String _refreshToken;
  DateTime _expToken;
  DateTime _expRefreshToken;
  String _userId;
  String _username;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expToken != null && _expRefreshToken.isAfter(DateTime.now())) {
      if (_expToken.isBefore(DateTime.now())) _getNewToken();
      return _token ?? null;
    }
  }

  String get userId {
    return _userId;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _refreshToken = null;
    _username = null;
    _expRefreshToken = null;
    _expToken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) return false;
    final userData = json.decode(prefs.getString("userData"));
    _expToken = DateTime.parse(userData["expInToken"]);
    _expRefreshToken = DateTime.parse(userData["expInToken"]);
    _userId = userData["userId"];
    _token = userData["token"];
    _refreshToken = userData["refreshToken"];
    _username = userData["username"];
    if (!isAuth) return false;
    _autoRefresh();
    notifyListeners();
    return true;
  }

  Future<void> storeValues() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "token": _token,
      "refreshToken": _refreshToken,
      "userId": _userId,
      "username": _username,
      "expInRefreshToken": _expRefreshToken.toIso8601String(),
      "expInToken": _expToken.toIso8601String()
    });
    prefs.setString("userData", userData);
  }

  Future<void> signup(String email, String username, String password) async {
    return _authenticate(
      {"username": username, "email": email, "password": password},
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
    try {
      final response = await http.post(
        url,
        body: json.encode(body),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData.containsKey("error"))
        throw HttpException(responseData["error"]);
      saveData(responseData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> _getNewToken() async {
    print("GETTING NEW TOKEN");
    while (true) {
      try {
        final response = await http.post(URL_AUTH_REFRESH_TOKEN,
            headers: {"x-access-tokens": _refreshToken});
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

  void saveData(Map<String, dynamic> responseData) {
    _token = responseData["token"];
    _refreshToken = responseData["refreshToken"];
    _username = responseData["username"];
    _userId = responseData["uid"];
    _expToken =
        DateTime.now().add(Duration(seconds: responseData["expInToken"]));
    _expRefreshToken = DateTime.now()
        .add(Duration(seconds: responseData["expInRefreshToken"]));
    _autoRefresh();
    storeValues();
    notifyListeners();
  }

  void _autoRefresh() {
    final timeToLogout = _expToken.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToLogout), _getNewToken);
  }

  // void _autoLogout() {
  //   final timeToLogout = _expRefreshToken.inSeconds;
  //   Timer(Duration(seconds: timeToLogout), logout);
  // }
}
