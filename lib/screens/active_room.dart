import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/widgets/creator_vote_tile.dart';
import 'package:firevote/widgets/danger_button.dart';
import 'package:firevote/widgets/vote_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveRoom extends StatefulWidget {
  @override
  _ActiveRoomState createState() => _ActiveRoomState();
}

class _ActiveRoomState extends State<ActiveRoom> {
  Map votesMap = {};
  Future<void> getResults(VoteRoom voteRoom) async {
    var doc = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(voteRoom.roomDetails.roomId)
        .get();
    print(doc.data());
    var votesMapData = doc.data()['votes'] as Map;
    votesMapData.forEach((key, value) {
      votesMap[key] = value;
      print(votesMap);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final voteRoom = Provider.of<VoteRoom>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(voteRoom.roomDetails.roomName),
              SizedBox(width: 10),
              FlatButton(
                child: Text('Get Results'),
                onPressed: () async {
                  await getResults(voteRoom);
                },
              )
            ],
          ),
          Text(voteRoom.roomDetails.roomId),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: voteRoom.roomDetails.voteFields.entries.map((field) {
                return CreatorVoteTile(field.value, votesMap[field.key] ?? 0);
              }).toList()),
          DangerButton(text: 'Close Room', onPressed: voteRoom.closeRoom)
        ],
      ),
    );
  }
}

//FOR REALTIME UPDATES
// StreamBuilder<DocumentSnapshot>(
//            stream: FirebaseFirestore.instance
//                .collection('rooms')
//                .doc(voteRoom.roomDetails.roomId)
//                .snapshots(),
//            builder: (ctx, snapshot) => Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: voteRoom.roomDetails.voteFields.entries.map((field) {
//                  print('streaming');
//                  return Text(
//                      '${field.key}: ${field.value}-${snapshot.data.data()['votes'][field.key]}');
//                }).toList()),
//          ),
