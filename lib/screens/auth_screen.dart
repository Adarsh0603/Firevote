import 'package:firevote/data/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Log in to Continue'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SignInButton(
              Buttons.GoogleDark,
              text: "Sign in with Google",
              onPressed: () async {
                await Provider.of<Auth>(context, listen: false)
                    .signInWithGoogle();
              },
            ),
          ),
        ],
      ),
    );
  }
}
