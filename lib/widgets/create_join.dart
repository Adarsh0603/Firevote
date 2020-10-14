import 'package:firevote/widgets/create_vote_room.dart';
import 'package:firevote/widgets/join_vote_room.dart';
import 'package:firevote/widgets/no_room_content.dart';
import 'package:flutter/material.dart';

class CreateJoin extends StatelessWidget {
  void navigate(BuildContext context, bool create) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            create ? CreateVoteRoom() : JoinVoteRoom()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height:
          MediaQuery.of(context).size.height - AppBar().preferredSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlatButton(
                  color: Colors.blue[300],
                  child: Text(
                    'Create Voteroom',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => navigate(context, true),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: OutlineButton(
                  child: Text(
                    'Join Voteroom',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => navigate(context, false),
                ),
              ),
            ],
          ),
          Expanded(child: NoRoomContent()),
        ],
      ),
    );
  }
}
