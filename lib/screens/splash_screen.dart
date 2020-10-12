import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        'FireVote',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
      )),
    );
  }
}
