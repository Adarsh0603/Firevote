import 'package:firebase_auth/firebase_auth.dart';
import 'package:firevote/data/auth.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/screens/auth_screen.dart';
import 'package:firevote/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.data == null)
          return AuthScreen();
        else {
          Provider.of<VoteRoom>(context, listen: false)
              .initializeUser(snapshot.data);
          return HomeScreen();
        }
      },
    );
  }
}
