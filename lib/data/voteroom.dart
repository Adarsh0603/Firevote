import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firevote/modals/room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteRoom with ChangeNotifier {
  final _fireStore = FirebaseFirestore.instance;

  User _user;
  String _roomId;
  DocumentSnapshot _currentDoc;
  bool _isCreator = false;
  bool _freshVote = false;
  Room _roomDetails;

  void initializeUser(User user) {
    _user = user;
  }

  //Getters
  User get user => _user;
  Room get roomDetails => _roomDetails;
  bool get isCreator => _isCreator;
  DocumentSnapshot get currentDoc => _currentDoc;
  bool get freshVote => _freshVote;

  //Checks if voter exists in room and has voted
  bool get hasAlreadyVoted {
    var votersList = _currentDoc.data()['voted'] as List;
    return votersList.indexWhere((element) => element['uid'] == _user.uid) != -1
        ? true
        : false;
  }

  //Setters
  void updateDoc(DocumentSnapshot latestDoc) {
    _currentDoc = latestDoc;
    notifyListeners();
  }

  void setFreshVote() {
    _freshVote = true;
    notifyListeners();
  }

  //Create New VoteRoom
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
      'postResults': false,
      'resultsDeclared': false,
      'isActive': true,
      'votes': votes,
      'voted': [],
    });
    _roomId = response.id;

    Room newRoom = Room(
        creatorName: _user.displayName,
        roomId: _roomId,
        roomName: roomName,
        creatorId: _user.uid,
        voteFields: voteFields);
    _roomDetails = newRoom;
    _isCreator = true;
    print('createVoteRoom()');

    notifyListeners();
  }

  //Gets Pre-existing active room details from Firebase
  Future<bool> getRoomIdAndDoc() async {
    try {
      print('getRoomIdAndDoc()');
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

  //Process active room details for app use.
  Future<void> getActiveRoom() async {
    _isCreator = await getRoomIdAndDoc();
    final roomDetails = _currentDoc;
    Room activeRoomFromDb = Room(
      creatorName: roomDetails.data()['creatorName'],
      roomName: roomDetails.data()['roomName'],
      roomId: _roomId,
      creatorId: _isCreator ? _user.uid : roomDetails.data()['creatorId'],
      voteFields: roomDetails.data()['voteFields'],
    );
    _roomDetails = activeRoomFromDb;
    print('getActiveRoom()');

    notifyListeners();
  }

  //Join VoteRoom with RoomId
  Future<void> joinRoom(String roomId) async {
    try {
      print('joinRoom()');

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
      notifyListeners();
      print('Joined Room Successfully');
    } catch (e) {
      throw 'Cannot join room';
    }
  }

  //Votes for user selected voteField
  Future<void> vote(String field, String title) async {
    try {
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
      print('vote()');
    } catch (e) {
      throw 'Vote Failed';
    }
  }

  List<DataRow> voteResults() {
    var voteMap = _currentDoc.data()['votes'] as Map;
    List<DataRow> voteRows = [];
    voteMap.forEach((key, value) {
      voteRows.add(DataRow(cells: [
        DataCell(Text(_currentDoc.data()['voteFields'][key])),
        DataCell(Text(value.toString()))
      ]));
    });
    return voteRows;
  }

  //Checks selected voteField
  bool checkVotedField(String fieldValue) {
    print('checkVoteField()');

    var votersList = _currentDoc.data()['voted'] as List;
    var selectedFieldIfAny = votersList.firstWhere(
        (element) =>
            element['voteTo'] == fieldValue && element['uid'] == _user.uid,
        orElse: () => null);
    if (selectedFieldIfAny == null) {
      return false;
    }
    return true;
  }

  //Posts results for all voters.
  Future<void> postResults() async {
    await _fireStore
        .collection('rooms')
        .doc(_roomId)
        .update({'postResults': true, 'resultsDeclared': true});
  }

  //Close room by Creator
  Future<void> closeRoom() async {
    print('closeRoom()');
    await _fireStore
        .collection('rooms')
        .doc(_roomId)
        .update({'isActive': false});
    await resetState();
  }

  //Leave Room by voter
  void leaveRoom() async {
    print('leaveRoom()');

    await resetState();
  }

  void signingOut() async {
    print('signingOut()');
    await resetState();
  }

  //Resets State variables.
  Future<void> resetState() async {
    _roomDetails = null;
    _roomId = null;
    _isCreator = false;
    _currentDoc = null;
    _freshVote = false;
    notifyListeners();
  }
}
