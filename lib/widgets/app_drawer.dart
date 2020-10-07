import 'package:firevote/data/auth.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/widgets/join_vote_room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  void signOut(BuildContext context) async {
    Navigator.of(context).pop();
    Provider.of<VoteRoom>(context, listen: false).signingOut();
    await Provider.of<Auth>(context, listen: false).signOut();
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
              title: Text('Sign Out'),
              onTap: () => signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
