import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final double width;
  final double thickness;

  CustomLoader({this.width = 12, this.thickness = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      child: CircularProgressIndicator(
        strokeWidth: thickness,
      ),
    );
  }
}
