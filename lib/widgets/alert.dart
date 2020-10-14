import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String content;
  final Function onAgree;
  final Function onCancel;

  Alert(
      {@required this.title,
      @required this.content,
      @required this.onAgree,
      @required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
      title: Text(title),
      actions: [
        FlatButton(onPressed: onAgree, child: Text('Yes')),
        FlatButton(onPressed: onCancel, child: Text('No')),
      ],
    );
  }
}
