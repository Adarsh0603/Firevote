import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class VoteRoom with ChangeNotifier {
  User _user;
  bool _isActive = false;
  String _roomId;
  final _fireStore = FirebaseFirestore.instance;
  void initializeUser(User user) {
    _user = user;
  }

  bool get isRoomActive => _isActive;

  Future<void> createVoteRoom(
      String roomName, Map<String, String> voteFields) async {
    final response = await _fireStore.collection('rooms').add({
      'roomName': roomName,
      'creatorName': _user.displayName,
      'creatorId': _user.uid,
      'voteFields': voteFields
    });
    _roomId = response.id;
    await _fireStore
        .collection('rooms')
        .doc(_roomId)
        .update({'isActive': true});
    _isActive = true;
    notifyListeners();
  }

  Future<void> getActiveRoom() async {
    final response = await _fireStore
        .collection('rooms')
        .where('creatorId', isEqualTo: _user.uid)
        .where('isActive', isEqualTo: true)
        .get();
    print(response.docs[0].id);
    _roomId = response.docs[0].id;
    _isActive = true;
    notifyListeners();
  }

  void update() {}
}
