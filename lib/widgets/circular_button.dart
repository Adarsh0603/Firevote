import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CircularButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: () async {
        await Provider.of<VoteRoom>(context, listen: false)
            .createVoteRoom('My room');
      },
      borderSide: BorderSide(color: kAccentColor),
      child: Icon(
        Icons.add,
        size: 35.0,
        color: kAccentColor,
      ),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }
}
