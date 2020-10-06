import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firevote/modals/room.dart';
import 'package:flutter/material.dart';

class JoinRoom with ChangeNotifier {
  final _fireStore = FirebaseFirestore.instance;
  Room _roomDetails;
  Room get roomDetails => _roomDetails;

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
    notifyListeners();
  }
}
