import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Utils {
  static void showSnack(
      {@required BuildContext context, @required String content}) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(seconds: 2),
    ));
  }

  static void shareId(String id, String roomName) async {
    Share.share('Firevote Room\nName: $roomName\nRoom Id: $id',
        subject: 'Firevote Room Id');
  }
}
