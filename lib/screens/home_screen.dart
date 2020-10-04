import 'package:firevote/constants.dart';
import 'package:firevote/widgets/circular_button.dart';
import 'package:firevote/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: CustomAppBar.getAppBar(context, 'Firevote'),
      body: Center(child: CircularButton()),
    );
  }
}
