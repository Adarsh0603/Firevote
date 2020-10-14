import 'package:firevote/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar {
  static getAppBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      // elevation:,
      backgroundColor: kPrimaryColor,
      title: Text(title, style: kAppBarTextStyle),
    );
  }
}
