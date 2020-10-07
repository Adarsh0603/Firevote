import 'package:firevote/data/voteroom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoteTile extends StatelessWidget {
  final String title;
  final String field;

  VoteTile(this.title, this.field);
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
                content: Text('Voting...'),
              ));
      bool result = await Provider.of<VoteRoom>(context, listen: false)
          .vote(field, title);
      Navigator.of(context, rootNavigator: true).pop();
      if (result) showSnack('Vote submitted successfully.', context);
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      showSnack(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 3,
        child: Container(
          color: Colors.white,
          child: ListTile(
            onTap: () => onVote(context),
            title: Text(title),
          ),
        ),
      ),
    );
  }
}
