import 'package:firevote/constants.dart';
import 'package:firevote/data/joinroom.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinVoteRoom extends StatefulWidget {
  @override
  _JoinVoteRoomState createState() => _JoinVoteRoomState();
}

class _JoinVoteRoomState extends State<JoinVoteRoom> {
  String roomId;

  void joinVoteRoom() async {
    await Provider.of<VoteRoom>(context, listen: false).joinRoom(roomId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
      child: Column(
        children: [
          Text('Join VoteRoom', style: kHeadingTextStyle),
          TextField(
            decoration:
                kRoomFormInputDecoration.copyWith(hintText: 'Paste Room Id'),
            onChanged: (value) {
              roomId = value;
            },
          ),
          FlatButton(
            child: Text('Join'),
            onPressed: () {
              joinVoteRoom();
            },
          )
        ],
      ),
    );
  }
}
