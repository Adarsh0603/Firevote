import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/utils.dart';
import 'package:firevote/widgets/creator_vote_tile.dart';
import 'package:firevote/widgets/danger_button.dart';
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
    var votesMapData = doc.data()['votes'] as Map;
    votesMapData.forEach((key, value) {
      votesMap[key] = value;
    });
    voteRoom.updateDoc(doc);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final currentRoom =
        Provider.of<VoteRoom>(context, listen: false).currentDoc;
    if (currentRoom == null) return;
    final votesMapData = currentRoom.data()['votes'] as Map;
    votesMapData.forEach((key, value) {
      votesMap[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final voteRoom = Provider.of<VoteRoom>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(voteRoom.roomDetails.roomName,
                        style: kRoomNameTextStyle),
                    Text('ID-${voteRoom.roomDetails.roomId}',
                        style: kRoomIdTextStyle),
                  ],
                ),
                FlatButton(
                  color: Colors.white,
                  child: Text('Share Room ID'),
                  onPressed: () => Utils.shareId(voteRoom.roomDetails.roomId,
                      voteRoom.roomDetails.roomName),
                )
              ],
            ),
            SizedBox(height: 10),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: voteRoom.roomDetails.voteFields.entries.map((field) {
                  return CreatorVoteTile(field.value, votesMap[field.key] ?? 0);
                }).toList()),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                child: Text('Get Latest Results'),
                onPressed: () async {
                  await getResults(voteRoom);
                },
              ),
            ),
            DangerButton(text: 'Close Room', onPressed: voteRoom.closeRoom),
          ],
        ),
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
