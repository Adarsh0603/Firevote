import 'package:flutter/material.dart';

const kPrimaryColor = Colors.white;
const kAppBarTextStyle = TextStyle(color: Colors.black);
const kAccentColor = Color(0xffc0a062);

//AuthScreen

const kAuthFormInputDecoration = InputDecoration(hintText: 'Name');
const kJoinRoomInputDecoration = InputDecoration(
    hintText: 'Enter Room Id',
    border: InputBorder.none,
    contentPadding: EdgeInsets.only(left: 8));
const kRoomFormInputDecoration =
    InputDecoration(hintText: 'Room Name', border: InputBorder.none);
//Room Form
const kHeadingTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
const kRoomNameTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
const kRoomCreatorTextStyle = TextStyle(fontSize: 14, color: Colors.grey);
const kRoomIdTextStyle = TextStyle(fontSize: 12, color: Colors.grey);
const kResultsTextStyle = TextStyle(fontWeight: FontWeight.bold);
const kResultsWaitingTextStyle = TextStyle(color: Colors.grey);
