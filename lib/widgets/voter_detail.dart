import 'package:flutter/material.dart';

class VoterDetail extends StatelessWidget {
  final String name;
  final String email;
  final int index;

  VoterDetail(this.name, this.email, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      color: index % 2 == 0 ? Colors.grey[200] : Colors.grey[100],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
            child: Row(
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
            Text(' ($email)', style: TextStyle(fontSize: 12)),
          ],
        )),
      ),
    );
  }
}
