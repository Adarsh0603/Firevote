import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firevote/modals/room.dart';
import 'package:flutter/cupertino.dart';

class VoteRoom with ChangeNotifier {
  User _user;
  bool _isActive = false;
  String _roomId;
  final _fireStore = FirebaseFirestore.instance;
  void initializeUser(User user) {
    _user = user;
  }

  User get user => _user;
  Room _roomDetails;
  Room get roomDetails => _roomDetails;

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
    Room newRoom = Room(
        creatorName: _user.displayName,
        roomId: _roomId,
        roomName: roomName,
        creatorId: _user.uid,
        voteFields: voteFields);
    _roomDetails = newRoom;
    notifyListeners();
  }

  Future<void> getRoomId() async {
    final response = await _fireStore
        .collection('rooms')
        .where('creatorId', isEqualTo: _user.uid)
        .where('isActive', isEqualTo: true)
        .get();

    if (response == null) {
      final response = await _fireStore
          .collection('rooms')
          .where('members', arrayContains: user.uid)
          .get();
      _roomId = response.docs[0].id;
      return;
    }
    _roomId = response.docs[0].id;
  }

  Future<void> getActiveRoom() async {
    await getRoomId();
    final roomDetails = await _fireStore.collection('rooms').doc(_roomId).get();
    print(roomDetails.data());
    Room activeRoomFromDb = Room(
      creatorName: roomDetails.data()['creatorName'],
      roomName: roomDetails.data()['roomName'],
      roomId: _roomId,
      creatorId: _user.uid,
      voteFields: roomDetails.data()['voteFields'],
    );
    _roomDetails = activeRoomFromDb;
    _isActive = true;

    notifyListeners();
  }

  Future<void> joinRoom(String roomId) async {
    final response = await _fireStore.collection('rooms').doc(roomId).get();
    final roomData = response.data();
    Room joinedRoom = Room(
        creatorName: roomData['creatorName'],
        roomName: roomData['roomName'],
        creatorId: roomData['creatorId'],
        voteFields: roomData['voteFields'],
        roomId: roomData['roomId']);
    await _fireStore.collection('rooms').doc(roomId).update({
      'members': FieldValue.arrayUnion([user.uid])
    });

    _roomDetails = joinedRoom;
    notifyListeners();
  }

  void leaveRoom() {
    _roomDetails = null;
    notifyListeners();
  }

  void update() {}
}
