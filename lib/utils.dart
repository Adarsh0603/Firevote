import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static void saveRoomLocally({String id, bool isCreator}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomData = jsonEncode({'roomId': id, 'isCreator': isCreator});
    prefs.setString('roomData', roomData);
    print('Saved Local Data : $roomData');
  }

  static Future<Map<String, dynamic>> fetchRoomLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomDataJson = prefs.getString('roomData');
    Map<String, dynamic> roomData = jsonDecode(roomDataJson);
    print('Fetched Local Data : $roomDataJson');
    return roomData;
  }

  static Future<void> deleteRoomLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Deleted Local Data');
    prefs.clear();
  }
}
