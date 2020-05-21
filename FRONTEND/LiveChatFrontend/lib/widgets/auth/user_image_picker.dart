import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function imagePickFn;
  File _pickedImage;
  UserImagePicker(this.imagePickFn, this._pickedImage);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  void _pickImage() async {
    final ImageSource imageSource = await _showDialog();
    if (imageSource != null) {
      final image = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 128,
        maxHeight: 128,
      );
      setState(() {
        widget._pickedImage = image;
      });
      widget.imagePickFn(widget._pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: widget._pickedImage != null
              ? FileImage(widget._pickedImage)
              : null,
          child: Text(
            widget._pickedImage != null ? "" : "Select\nimage",
          ),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text("add image"),
        ),
      ],
    );
  }

  Future<ImageSource> _showDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera),
                    Text("CAMERA"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera),
                    Text("ALBUM"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
