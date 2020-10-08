import 'package:flutter/material.dart';

class CreatorVoteTile extends StatelessWidget {
  final String title;
  final int votes;

  CreatorVoteTile(this.title, this.votes);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Text('Votes: $votes')],
    );
  }
}
