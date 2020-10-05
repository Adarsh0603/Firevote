import 'package:firevote/data/voteroom.dart';
import 'package:firevote/widgets/join_vote_room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  void joinRoom(BuildContext context) async {
    Navigator.of(context).pop();

    showBottomSheet(
        backgroundColor: Colors.grey[100],
        context: context,
        builder: (ctx) => JoinVoteRoom());
  }

  @override
  Widget build(BuildContext context) {
    final voteRoom = Provider.of<VoteRoom>(context, listen: false);

    return Drawer(
      child: SafeArea(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.person_outline),
                title: Text(voteRoom.user.displayName),
              ),
            ),
            ListTile(
              title: Text('Create Room'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Join Room'),
              onTap: () => joinRoom(context),
            ),
          ],
        ),
      ),
    );
  }
}
