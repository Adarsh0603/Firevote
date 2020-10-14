import 'package:firevote/widgets/row_column_changer.dart';
import 'package:flutter/material.dart';

class NoRoomContent extends StatelessWidget {
  List<Widget> widgetList(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return [
      Spacer(),
      Image.asset(
        'images/voting.png',
        scale: orientation == Orientation.portrait ? 1 : 5,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No active voteroom',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'You are not connected to any voteroom.\nCreate or join one.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ],
      ),
      Spacer(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return RowColumnChanger(children: widgetList(context));
  }
}
