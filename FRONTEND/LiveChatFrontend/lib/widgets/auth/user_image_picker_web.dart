import 'package:flutter/material.dart';

class UserImagePickerWeb extends StatefulWidget {
  final Function pickeImageWeb;

  UserImagePickerWeb(this.pickeImageWeb);

  @override
  _UserImagePickerWebState createState() => _UserImagePickerWebState();
}

class _UserImagePickerWebState extends State<UserImagePickerWeb> {
  int active = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            color:
                active == 0 ? Theme.of(context).accentColor : Colors.grey[300],
            onPressed: () {
              setState(() {
                active = 0;
                widget.pickeImageWeb("assets/images/profile_icon_female.png");
              });
            },
            child: ListTile(
              leading: Icon(Icons.face),
              title: Text("Female"),
            ),
          ),
        ),
        Expanded(
          child: FlatButton(
            color:
                active == 1 ? Theme.of(context).accentColor : Colors.grey[300],
            onPressed: () {
              setState(() {
                active = 1;
                widget.pickeImageWeb("assets/images/profile_icon_male.jpg");
              });
            },
            child: ListTile(
              leading: Icon(Icons.tag_faces),
              title: Text("Male"),
            ),
          ),
        ),
      ],
    );
  }
}
