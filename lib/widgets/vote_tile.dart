import 'package:firevote/data/voteroom.dart';
import 'package:firevote/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoteTile extends StatefulWidget {
  final String title;
  final String field;
  final bool wasSelected;
  final bool hasAlreadyVoted;
  VoteTile(this.title, this.field, this.wasSelected, this.hasAlreadyVoted);

  @override
  _VoteTileState createState() => _VoteTileState();
}

class _VoteTileState extends State<VoteTile> {
  bool hasVoted = false;
  void onRevote(BuildContext context) {
    Utils.showSnack(context: context, content: 'You have already voted');
  }

  void onVote(BuildContext context) async {
    try {
      final voteRoom = Provider.of<VoteRoom>(context, listen: false);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    Spacer(),
                    Text('Hold On'),
                  ],
                ),
              ));
      bool result = await voteRoom.vote(widget.field, widget.title);
      Navigator.of(context, rootNavigator: true).pop();
      if (result)
        Utils.showSnack(context: context, content: 'Voted successfully.');
      if (!voteRoom.freshVote) voteRoom.setFreshVote();

      setState(() {
        hasVoted = true;
      });
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Utils.showSnack(context: context, content: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final voteRoom = Provider.of<VoteRoom>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Material(
        elevation: hasVoted ? 5 : 3,
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: widget.wasSelected || hasVoted
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
            onTap: () => widget.hasAlreadyVoted || voteRoom.freshVote
                ? onRevote(context)
                : onVote(context),
            title: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
