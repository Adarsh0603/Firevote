import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firevote/modals/room.dart';
import 'package:flutter/cupertino.dart';

class VoteRoom with ChangeNotifier {
  User _user;
  bool _isActive = false;
  String _roomId;
  final _fireStore = FirebaseFirestore.instance;
  DocumentSnapshot currentDoc;

  void initializeUser(User user) {
    _user = user;
  }

  User get user => _user;
  Room _roomDetails;
  Room get roomDetails => _roomDetails;

  bool get isRoomActive => _isActive;

  Future<void> createVoteRoom(
      String roomName, Map<String, String> voteFields) async {
    Map votes = {};
    voteFields.forEach((key, value) {
      votes[key] = 0;
    });

    final response = await _fireStore.collection('rooms').add({
      'roomName': roomName,
      'creatorName': _user.displayName,
      'creatorId': _user.uid,
      'voteFields': voteFields,
      'votes': votes,
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

  Future<bool> getRoomId() async {
    final response = await _fireStore
        .collection('rooms')
        .where('creatorId', isEqualTo: _user.uid)
        .where('isActive', isEqualTo: true)
        .get();
    print(response);
    if (response.docs.length == 0) {
      final response = await _fireStore
          .collection('rooms')
          .where('members', arrayContains: _user.uid)
          .get();
      _roomId = response.docs[0].id;
      return false;
    }
    _roomId = response.docs[0].id;
    return true;
  }

  Future<void> getActiveRoom() async {
    bool isCreator = await getRoomId();
    final roomDetails = await _fireStore.collection('rooms').doc(_roomId).get();
    print(roomDetails.data());
    Room activeRoomFromDb = Room(
      creatorName: roomDetails.data()['creatorName'],
      roomName: roomDetails.data()['roomName'],
      roomId: _roomId,
      creatorId: isCreator ? _user.uid : roomDetails.data()['creatorId'],
      voteFields: roomDetails.data()['voteFields'],
    );
    _roomDetails = activeRoomFromDb;
    _isActive = true;
    currentDoc = roomDetails;
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

    _roomDetails = joinedRoom;
    currentDoc = response;
    notifyListeners();
  }

  void leaveRoom() {
    _roomDetails = null;
    notifyListeners();
  }

  Future<void> vote(String field, String title) async {
    var doc = await _fireStore.collection('rooms').doc(_roomId).get();
    List voteList = doc.data()['voted'] as List;
    print(voteList.indexWhere((element) => element['uid'] == _user.uid));
    if (voteList.indexWhere((element) => element['uid'] == _user.uid) != -1)
      return;
    await _fireStore
        .collection('rooms')
        .doc(_roomId)
        .update({'votes.$field': FieldValue.increment(1)});
    await _fireStore.collection('rooms').doc(_roomId).update({
      'voted': FieldValue.arrayUnion([
        {'uid': user.uid, 'name': user.displayName, 'voteTo': title}
      ])
    });
  }

  void update() {}
}
