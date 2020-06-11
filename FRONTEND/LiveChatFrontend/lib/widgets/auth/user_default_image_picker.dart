import 'package:flutter/material.dart';

class UserDefaultPicker extends StatefulWidget {
  final Function pickedImageWeb;

  UserDefaultPicker(this.pickedImageWeb);

  @override
  _UserDefaultPickerState createState() => _UserDefaultPickerState();
}

class _UserDefaultPickerState extends State<UserDefaultPicker> {
  int active = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildButton(
              context, Icons.tag_faces, "profile_icon_male.jpg", "Male"),
        ),
        Expanded(
          child: buildButton(
              context, Icons.face, "profile_icon_female.png", "Female"),
        ),
      ],
    );
  }

  FlatButton buildButton(
      BuildContext context, IconData icon, String imagePath, String type) {
    return FlatButton(
      color: active == (type == "Male" ? 1 : 0)
          ? Theme.of(context).accentColor
          : Colors.grey[300],
      onPressed: () {
        setState(() {
          active = (type == "Male" ? 1 : 0);
          widget.pickedImageWeb("assets/images/$imagePath");
        });
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(icon),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: Text(type, maxLines: 1),
          ),
        ],
      ),
    );
  }
}
