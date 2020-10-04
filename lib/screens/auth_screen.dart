import 'package:firevote/data/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Sign in with Google'),
          onPressed: () async {
            await Provider.of<Auth>(context, listen: false).signInWithGoogle();
          },
        ),
      ),
    );
  }
}
