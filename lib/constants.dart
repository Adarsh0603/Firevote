import 'package:flutter/material.dart';

const kPrimaryColor = Colors.white;
const kAppBarTextStyle = TextStyle(color: Colors.black54);
const kAccentColor = Colors.green;
const kWhiteText = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
//AuthScreen

const kAuthFormInputDecoration = InputDecoration(hintText: 'Name');
const kJoinRoomInputDecoration = InputDecoration(
    hintText: 'Enter Room Id',
    border: InputBorder.none,
    contentPadding: EdgeInsets.only(left: 8));
const kRoomFormInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.only(left: 8),
    fillColor: Colors.grey,
    hintText: 'Enter Room Name',
    border: InputBorder.none);
//Room Form
const kHeadingTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
const kRoomNameTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white);
const kRoomCreatorTextStyle = TextStyle(fontSize: 14, color: Colors.grey);
const kRoomIdTextStyle = TextStyle(fontSize: 12, color: Colors.grey);
const kResultsTextStyle = TextStyle(fontWeight: FontWeight.bold);
const kResultsWaitingTextStyle = TextStyle(color: Colors.grey);
