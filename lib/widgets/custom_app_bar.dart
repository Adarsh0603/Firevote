import 'package:firevote/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar {
  static getAppBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(title, style: kAppBarTextStyle),
    );
  }
}
