import 'package:firevote/data/voteroom.dart';
import 'package:firevote/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoteTile extends StatefulWidget {
  final String title;
  final String field;

  VoteTile(this.title, this.field);

  @override
  _VoteTileState createState() => _VoteTileState();
}

class _VoteTileState extends State<VoteTile> {
  bool hasVoted = false;
  void showSnack(text, context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 1),
    ));
  }

  void onVote(BuildContext context) async {
    try {
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
      bool result = await Provider.of<VoteRoom>(context, listen: false)
          .vote(widget.field, widget.title);
      Navigator.of(context, rootNavigator: true).pop();
      if (result)
        Utils.showSnack(context: context, content: 'Voted successfully.');

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Material(
        elevation: hasVoted ? 5 : 3,
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading:
                hasVoted ? Icon(Icons.check_circle, color: Colors.green) : null,
            onTap: () => onVote(context),
            title: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
