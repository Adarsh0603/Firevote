import 'package:firevote/data/voteroom.dart';
import 'package:firevote/widgets/create_vote_room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateJoinRoom extends StatelessWidget {
  void createRoom(BuildContext context) async {
    showBottomSheet(
        backgroundColor: Colors.grey[200],
        context: context,
        builder: (ctx) => CreateVoteRoom());
  }

  void joinRoom(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            color: Colors.greenAccent,
            child: Text('Create Voteroom'),
            onPressed: () => createRoom(context),
          ),
          FlatButton(
            child: Text('Join Voteroom'),
            onPressed: () => joinRoom(context),
          ),
        ],
      ),
    );
  }
}
