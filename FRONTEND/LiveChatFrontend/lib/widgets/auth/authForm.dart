import 'dart:convert';
import 'dart:io';

import 'package:LiveChatFrontend/providers/auth_provider.dart';
import 'package:LiveChatFrontend/widgets/auth/user_image_picker.dart';
import 'package:LiveChatFrontend/widgets/auth/user_default_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key key,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _isLogin = false;
  var _defaultPhoto = true;
  var _isLoading = false;
  Map<String, dynamic> _authData = {
    "email": "",
    "username": "",
    "password": "",
    "imageFile": null,
  };

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    if (!_isLogin && _authData["imageFile"] == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please pick an Image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_isLogin) {
        await Provider.of<Auth>(context, listen: false).signin(
          _authData["email"],
          _authData["password"],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData["email"],
          _authData["username"],
          _authData["password"],
          base64Encode(identical(0, 0.0) || _defaultPhoto
              ? _authData["imageFile"]
              : _authData["imageFile"].readAsBytesSync()),
        );
      }
    } catch (error) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _pickedImage(File image) {
    _authData["imageFile"] = image;
  }

  Future<void> _pickedDefaultImage(String path) async {
    ByteData bytes = await rootBundle.load(path);
    _authData["imageFile"] = bytes.buffer.asUint8List();
  }

  List<Widget> imageForm() {
    return [
      if (!identical(0, 0.0))
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _authData["imageFile"] = null;
              setState(() => _defaultPhoto = !_defaultPhoto);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Switch Image"),
                Icon(Icons.switch_camera),
              ],
            ),
          ),
        ),
      if (!_defaultPhoto) UserImagePicker(_pickedImage, _authData["imageFile"]),
      if (identical(0, 0.0) || _defaultPhoto)
        UserDefaultPicker(_pickedDefaultImage)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (!_isLogin) ...imageForm(),
                      if (!_isLogin)
                        TextFormField(
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
                          key: ValueKey("username"),
                          onSaved: (newValue) =>
                              _authData["username"] = newValue.trim(),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Username must not be empty";
                            if (value.contains(" "))
                              return "Username must no contain spaces";
                            if (value.length < 4)
                              return "Username must be at least 4 characters long";
                            return null;
                          },
                          decoration: InputDecoration(labelText: "Username"),
                        ),
                      TextFormField(
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        key: ValueKey("email"),
                        onSaved: (newValue) =>
                            _authData["email"] = newValue.trim(),
                        validator: (value) => (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value))
                            ? "Please enter a valide email"
                            : null,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: "Email address"),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        key: ValueKey("password"),
                        onSaved: (newValue) =>
                            _authData["password"] = newValue.trim(),
                        validator: (value) {
                          if (value.isEmpty)
                            return "Password must not be empty";
                          if (value.contains(" "))
                            return "Password must no contain spaces";
                          if (value.length < 7)
                            return "Password must be at least 7 characters long";
                          return null;
                        },
                        decoration: InputDecoration(labelText: "Password"),
                        obscureText: true,
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: ValueKey("Confirm password"),
                          validator: (value) =>
                              (value != _passwordController.text)
                                  ? "Password doesn't match"
                                  : null,
                          decoration:
                              InputDecoration(labelText: "Confirm password"),
                          obscureText: true,
                        ),
                      SizedBox(
                        height: 12,
                      ),
                      if (!_isLoading)
                        RaisedButton(
                          color: Theme.of(context).accentColor.withOpacity(0.8),
                          child: Text(_isLogin ? "Login" : "SignUp"),
                          onPressed: _submitForm,
                        ),
                      if (!_isLoading)
                        FlatButton(
                          child: Text(_isLogin
                              ? "Create new Account"
                              : "I already have an account"),
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                        ),
                      if (_isLoading)
                        Center(
                            heightFactor: 3,
                            child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
