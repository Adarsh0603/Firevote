import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class VoteRoom with ChangeNotifier {
  User _user;
  final _fireStore = FirebaseFirestore.instance;
  void initializeUser(User user) {
    _user = user;
  }

  Future<void> createVoteRoom(
      String roomName, Map<String, String> voteFields) async {
    final response = await _fireStore.collection('rooms').add({
      'roomName': roomName,
      'creatorName': _user.displayName,
      'creatorId': _user.uid,
      'voteFields': voteFields
    });
    print(response);
  }

  void update() {}
}
