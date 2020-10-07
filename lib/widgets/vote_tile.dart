import 'package:firevote/data/voteroom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoteTile extends StatelessWidget {
  final String title;
  final String field;

  VoteTile(this.title, this.field);
  void onVote(BuildContext context) async {
    await Provider.of<VoteRoom>(context, listen: false).vote(field, title);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: () => onVote(context),
        title: Text(title),
      ),
    );
  }
}
