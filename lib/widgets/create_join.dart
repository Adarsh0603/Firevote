import 'package:firevote/widgets/create_vote_room.dart';
import 'package:firevote/widgets/join_vote_room.dart';
import 'package:firevote/widgets/no_room_content.dart';
import 'package:flutter/material.dart';

class CreateJoin extends StatelessWidget {
  void createRoom(BuildContext context) async {
    showBottomSheet(
        backgroundColor: Colors.grey[100],
        context: context,
        builder: (ctx) => CreateVoteRoom());
  }

  void joinRoom(BuildContext context) async {
//    showBottomSheet(
//        backgroundColor: Colors.grey[100],
//        context: context,
//        builder: (ctx) => JoinVoteRoom());
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => JoinVoteRoom()));
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
                  color: Colors.green,
                  child: Text(
                    'Create Voteroom',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => createRoom(context),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: OutlineButton(
                  child: Text(
                    'Join Voteroom',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => joinRoom(context),
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
