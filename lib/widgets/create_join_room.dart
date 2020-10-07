import 'package:firevote/widgets/create_vote_room.dart';
import 'package:firevote/widgets/join_vote_room.dart';
import 'package:flutter/material.dart';

class CreateJoinRoom extends StatelessWidget {
  void createRoom(BuildContext context) async {
    showBottomSheet(
        backgroundColor: Colors.grey[100],
        context: context,
        builder: (ctx) => CreateVoteRoom());
  }

  void joinRoom(BuildContext context) async {
    showBottomSheet(
        backgroundColor: Colors.grey[100],
        context: context,
        builder: (ctx) => JoinVoteRoom());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 1,
              child: ListTile(
                title: Text(
                  'Create Voteroom',
                  textAlign: TextAlign.center,
                ),
                onTap: () => createRoom(context),
              ),
            ),
            SizedBox(height: 20),
            Material(
              elevation: 1,
              child: ListTile(
                title: Text(
                  'Join Voteroom',
                  textAlign: TextAlign.center,
                ),
                onTap: () => joinRoom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
