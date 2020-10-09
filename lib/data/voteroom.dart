import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firevote/modals/room.dart';
import 'package:firevote/utils.dart';
import 'package:flutter/cupertino.dart';

class VoteRoom with ChangeNotifier {
  User _user;
  String _roomId;
  final _fireStore = FirebaseFirestore.instance;
  DocumentSnapshot _currentDoc;
  bool _isCreator = false;
  bool freshVote = false;

  void initializeUser(User user) {
    _user = user;
  }

  User get user => _user;
  Room _roomDetails;
  Room get roomDetails => _roomDetails;
  bool get isCreator => _isCreator;
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
    _roomDetails = newRoom;
    _isCreator = true;
    Utils.saveRoomLocally(id: _roomId, isCreator: true);
    notifyListeners();
  }

  Future<bool> getRoomId() async {
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
        _currentDoc = response.docs[0];
        _roomId = response.docs[0].id;
        return false;
      }
      _currentDoc = response.docs[0];
      _roomId = response.docs[0].id;
      return true;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getActiveRoom() async {
    //Uncomment to activate localisation
//    Map localRoomData = await Utils.fetchRoomLocally();
//    if (localRoomData == null || !localRoomData.containsKey('roomId')) {
//      return;
//    }
//    bool isCreator = localRoomData['isCreator'];
//    _roomId = localRoomData['roomId'];
    //Comment the below line to activate localisation

    _isCreator = await getRoomId();
    final roomDetails = _currentDoc;
    Room activeRoomFromDb = Room(
      creatorName: roomDetails.data()['creatorName'],
      roomName: roomDetails.data()['roomName'],
      roomId: _roomId,
      creatorId: _isCreator ? _user.uid : roomDetails.data()['creatorId'],
      voteFields: roomDetails.data()['voteFields'],
    );
    _roomDetails = activeRoomFromDb;
    _currentDoc = roomDetails;
    notifyListeners();
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
      _isCreator = false;
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
        {
          'uid': user.uid,
          'name': user.displayName,
          'voteTo': title,
          'email': user.email
        }
      ])
    });
    return true;
  }

  void updateDoc(DocumentSnapshot latestDoc) {
    _currentDoc = latestDoc;
    notifyListeners();
  }

  bool checkIfVoted(String fieldValue) {
    var votersList = _currentDoc.data()['voted'] as List;
    var selectedFieldIfAny = votersList.firstWhere(
        (element) =>
            element['voteTo'] == fieldValue && element['uid'] == _user.uid,
        orElse: () => null);
    print(selectedFieldIfAny);
    if (selectedFieldIfAny == null) {
      return false;
    }
    return true;
  }

  bool get hasAlreadyVoted {
    var votersList = _currentDoc.data()['voted'] as List;
    if (votersList.indexWhere((element) => element['uid'] == _user.uid) != -1) {
      return true;
    }
    return false;
  }

  void setFreshVote() {
    freshVote = true;
    notifyListeners();
  }

  Future<void> closeRoom() async {
    await _fireStore
        .collection('rooms')
        .doc(_roomId)
        .update({'isActive': false});
    await resetState();
  }

  void leaveRoom() async {
    await resetState();
  }

  void signingOut() async {
    await resetState();
  }

  Future<void> resetState() async {
    await Utils.deleteRoomLocally();
    _roomDetails = null;
    _roomId = null;
    _isCreator = false;
    _currentDoc = null;
    freshVote = false;
    notifyListeners();
  }
}
