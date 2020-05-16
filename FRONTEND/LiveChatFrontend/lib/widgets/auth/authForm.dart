import 'dart:io';

import 'package:LiveChatFrontend/widgets/auth/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key key,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _isLoading = false;
  Map<String, dynamic> formData = {
    "email": "",
    "username": "",
    "password": "",
    "imageFile": null,
  };

  Future<void> _submitForm(Map<String, dynamic> formData) async {
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    if (!_isLogin && formData["imageFile"] == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please pick an Image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _submitForm(formData);
    }
  }

  void _register(Map<String, dynamic> formData) async {
  }

  void _pickedImage(File image) {
    formData["imageFile"] = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 20.0,
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  key: ValueKey("email"),
                  onSaved: (newValue) => formData["email"] = newValue.trim(),
                  validator: (value) => (value.isEmpty || !value.contains("@"))
                      ? "Please enter a valide email"
                      : null,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email address"),
                ),
                if (!_isLogin)
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    key: ValueKey("username"),
                    onSaved: (newValue) =>
                        formData["username"] = newValue.trim(),
                    validator: (value) => (value.isEmpty || value.length < 7)
                        ? "Password must be at least 7 characters long"
                        : null,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                TextFormField(
                  key: ValueKey("password"),
                  onSaved: (newValue) => formData["password"] = newValue.trim(),
                  validator: (value) => (value.isEmpty || value.length < 4)
                      ? "Please enter at least 4 characters"
                      : null,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(
                  height: 12,
                ),
                if (!_isLoading)
                  RaisedButton(
                    child: Text(_isLogin ? "Login" : "SignUp"),
                    onPressed: _trySubmit,
                  ),
                if (!_isLoading)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_isLogin
                        ? "Create new Account"
                        : "I already have an account"),
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                  ),
                if (_isLoading)
                  Center(heightFactor: 3, child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
