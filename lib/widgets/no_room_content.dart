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
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) =>
            MediaQuery.of(context).orientation == Orientation.landscape
                ? Row(children: widgetList(context))
                : Column(children: widgetList(context)));
  }
}
