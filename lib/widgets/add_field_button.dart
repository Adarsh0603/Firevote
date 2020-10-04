import 'package:flutter/material.dart';

class AddFieldButton extends StatelessWidget {
  final Function onPressed;

  AddFieldButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        color: Colors.white,
        onPressed: onPressed,
        icon: Icon(Icons.add),
        label: Text('Add Field'));
  }
}
