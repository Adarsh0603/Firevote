import 'package:firevote/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar {
  static getAppBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.sort),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      backgroundColor: kPrimaryColor,
      title: Text('Firevote', style: kAppBarTextStyle),
    );
  }
}
