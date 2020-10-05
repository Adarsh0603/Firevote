import 'package:flutter/material.dart';

class VoteTile extends StatelessWidget {
  final String title;

  VoteTile(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(title),
      ),
    );
  }
}
