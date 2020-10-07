import 'package:flutter/material.dart';

class DangerButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  DangerButton({@required this.onPressed, @required this.text});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.red,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}
