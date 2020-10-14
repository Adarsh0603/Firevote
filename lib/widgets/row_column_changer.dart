import 'package:flutter/material.dart';

class RowColumnChanger extends StatelessWidget {
  final List<Widget> children;

  RowColumnChanger({this.children});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) =>
            MediaQuery.of(context).orientation == Orientation.landscape
                ? Row(children: children)
                : Column(children: children));
  }
}
