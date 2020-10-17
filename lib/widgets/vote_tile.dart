import 'package:firevote/constants.dart';
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
  void onRevote(BuildContext context, String message) {
    Utils.showSnack(context: context, content: message);
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

      await voteRoom.vote(widget.field, widget.title);
      Navigator.of(context, rootNavigator: true).pop();
      //TODO:Solve the bug here for all field votes.
      if (!voteRoom.freshVote) voteRoom.setFreshVote();
      setState(() {
        hasVoted = true;
      });
      Utils.showSnack(context: context, content: 'Voted successfully.');
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Utils.showSnack(context: context, content: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final voteRoom = Provider.of<VoteRoom>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Material(
        elevation: hasVoted || widget.wasSelected ? 5 : 0,
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: widget.wasSelected || hasVoted
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
            onTap: () => voteRoom.currentDoc.data()['postResults'] == true &&
                    widget.hasAlreadyVoted == false
                ? onRevote(context, 'The results are posted..cant vote.')
                : widget.hasAlreadyVoted || voteRoom.freshVote
                    ? onRevote(context, 'You have already voted.')
                    : onVote(context),
            title: Text(widget.title, style: kVoterNameTextStyle),
          ),
        ),
      ),
    );
  }
}
