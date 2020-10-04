import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class VoteRoom with ChangeNotifier {
  User _user;
  void initializeUser(User user) {
    _user = user;
    print(_user.displayName);
  }

  void update() {}
}
