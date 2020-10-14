import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData iconData;

  CustomIconButton({
    @required this.onPressed,
    @required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: onPressed == null ? Colors.grey : Colors.black,
      ),
    );
  }
}
