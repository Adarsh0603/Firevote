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
  String roomId = '';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Join Vote Room'),
        elevation: 0,
        actions: [
          FlatButton(
            textColor: Colors.green,
            disabledTextColor: Colors.grey,
            child: Text(
              'Join',
            ),
            onPressed: roomId.length == 0 ? null : joinVoteRoom,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Material(
                  elevation: 0,
                  color: Colors.grey[200],
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: kJoinRoomInputDecoration,
                    onChanged: (value) {
                      setState(() {
                        roomId = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
