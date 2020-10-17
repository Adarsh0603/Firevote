import 'package:firevote/data/auth.dart';
import 'package:firevote/data/voteroom.dart';
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
        child: Container(
          color: Colors.white,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Text(
                        'Firevotes',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                            fontSize: 28),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      // leading: Icon(Icons.person),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Logged In as:',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(voteRoom.user.displayName),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sign Out'),
                onTap: () => signOut(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
