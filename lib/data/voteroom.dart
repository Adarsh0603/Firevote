import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firevote/modals/room.dart';
import 'package:firevote/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoteRoom with ChangeNotifier {
  User _user;
  bool _isActive = false;
  String _roomId;
  final _fireStore = FirebaseFirestore.instance;
  DocumentSnapshot _currentDoc;

  void initializeUser(User user) {
    _user = user;
  }

  User get user => _user;
  Room _roomDetails;
  Room get roomDetails => _roomDetails;
  bool get isRoomActive => _isActive;
  DocumentSnapshot get currentDoc => _currentDoc;

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
      'voted': [],
    });
    _roomId = response.id;
    await _fireStore
        .collection('rooms')
        .doc(_roomId)
        .update({'isActive': true});
    Room newRoom = Room(
        creatorName: _user.displayName,
        roomId: _roomId,
        roomName: roomName,
        creatorId: _user.uid,
        voteFields: voteFields);
    _isActive = true;
    _roomDetails = newRoom;
    Utils.saveRoomLocally(id: _roomId, isCreator: true);
    notifyListeners();
  }

  Future<bool> getRoomId() async {
    print('getRoomId');
    try {
      final response = await _fireStore
          .collection('rooms')
          .where('creatorId', isEqualTo: _user.uid)
          .where('isActive', isEqualTo: true)
          .get();
      if (response.docs.length == 0) {
        final response = await _fireStore
            .collection('rooms')
            .where('members', arrayContains: _user.uid)
            .get();
        print(response.docs[0].data());
        _roomId = response.docs[0].id;
        return false;
      }
      _roomId = response.docs[0].id;
      return true;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getActiveRoom() async {
//    Map localRoomData = await Utils.fetchRoomLocally();
//    if (localRoomData == null || !localRoomData.containsKey('roomId')) {
//      return;
//    }
//    bool isCreator = localRoomData['isCreator'];
//    _roomId = localRoomData['roomId'];
    bool isCreator = await getRoomId();
    final roomDetails = await _fireStore.collection('rooms').doc(_roomId).get();
    Room activeRoomFromDb = Room(
      creatorName: roomDetails.data()['creatorName'],
      roomName: roomDetails.data()['roomName'],
      roomId: _roomId,
      creatorId: isCreator ? _user.uid : roomDetails.data()['creatorId'],
      voteFields: roomDetails.data()['voteFields'],
    );
    _roomDetails = activeRoomFromDb;
    _isActive = true;
    _currentDoc = roomDetails;
    notifyListeners();
  }

  Future<bool> checkIfVoted() async {
    var voteList = await _currentDoc.data()['voted'] as List;
    var votedIndex =
        voteList.indexWhere((element) => element['uid'] == user.uid);

    if (votedIndex == -1) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> joinRoom(String roomId) async {
    try {
      final response = await _fireStore.collection('rooms').doc(roomId).get();
      final roomData = response.data();
      Room joinedRoom = Room(
          creatorName: roomData['creatorName'],
          roomName: roomData['roomName'],
          creatorId: roomData['creatorId'],
          voteFields: roomData['voteFields'],
          roomId: roomId);
      await _fireStore.collection('rooms').doc(roomId).update({
        'members': FieldValue.arrayUnion([_user.uid])
      });
      _roomId = roomId;
      _roomDetails = joinedRoom;
      _currentDoc = response;
      Utils.saveRoomLocally(id: _roomId, isCreator: false);
      notifyListeners();
      print('Joined Room Successfully');
    } catch (e) {
      throw 'Cannot join room';
    }
  }

  Future<bool> vote(String field, String title) async {
    var doc = await _fireStore.collection('rooms').doc(_roomId).get();
    List voteList = doc.data()['voted'] as List;
    if (voteList.indexWhere((element) => element['uid'] == _user.uid) != -1) {
      throw 'You have already voted.';
    }
    await _fireStore.collection('rooms').doc(_roomId).update({
      'votes.$field': FieldValue.increment(1),
      'voted': FieldValue.arrayUnion([
        {'uid': user.uid, 'name': user.displayName, 'voteTo': title}
      ])
    });
    return true;
  }

  Future<void> closeRoom() async {
    await _fireStore
        .collection('rooms')
        .doc(_roomId)
        .update({'isActive': false});
    _isActive = false;
    _roomDetails = null;
    _roomId = null;
    _currentDoc = null;
    await Utils.deleteRoomLocally();
    notifyListeners();
  }

  void leaveRoom() async {
    _roomDetails = null;
    _currentDoc = null;
    await Utils.deleteRoomLocally();
    notifyListeners();
  }

  void signingOut() async {
    await Utils.deleteRoomLocally();
    _roomDetails = null;
    notifyListeners();
  }
}
