import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinVoteRoom extends StatefulWidget {
  @override
  _JoinVoteRoomState createState() => _JoinVoteRoomState();
}

class _JoinVoteRoomState extends State<JoinVoteRoom> {
  String roomId;

  void joinVoteRoom() async {
    try {
      await Provider.of<VoteRoom>(context, listen: false).joinRoom(roomId);
      Navigator.pop(context);
    } catch (e) {
      Utils.showSnack(context: context, content: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => Navigator.pop(context)),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Material(
                      elevation: 2,
                      child: TextField(
                        decoration: kJoinRoomInputDecoration,
                        onChanged: (value) {
                          roomId = value;
                        },
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text('Join'),
                    onPressed: () {
                      joinVoteRoom();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
