import 'package:flutter/material.dart';

class CreatorVoteTile extends StatelessWidget {
  final String title;
  final int votes;

  CreatorVoteTile(this.title, this.votes);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Text(
                '$votes ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Votes',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
