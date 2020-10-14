import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/utils.dart';
import 'package:firevote/widgets/alert.dart';
import 'package:firevote/widgets/creator_vote_tile.dart';
import 'package:firevote/widgets/custom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveRoom extends StatefulWidget {
  @override
  _ActiveRoomState createState() => _ActiveRoomState();
}

class _ActiveRoomState extends State<ActiveRoom> {
  Map votesMap = {};
  bool isGettingResults = false;
  Future<void> getResults(VoteRoom voteRoom) async {
    setState(() {
      isGettingResults = true;
    });
    var doc = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(voteRoom.roomDetails.roomId)
        .get();
    var votesMapData = doc.data()['votes'] as Map;
    votesMapData.forEach((key, value) {
      votesMap[key] = value;
    });
    voteRoom.updateDoc(doc);
    setState(() {
      isGettingResults = false;
    });
    Utils.showSnack(context: context, content: 'Updated Results.');
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
                    if (voteRoom.resultsPosted == false)
                      Text('ID-${voteRoom.roomDetails.roomId}',
                          style: kRoomIdTextStyle),
                  ],
                ),
                if (voteRoom.resultsPosted == false)
                  FlatButton(
                    color: Colors.blue,
                    child: Text(
                      'Invite',
                      style: kWhiteText,
                    ),
                    onPressed: () => Utils.shareId(voteRoom.roomDetails.roomId,
                        voteRoom.roomDetails.roomName),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: voteRoom.roomDetails.voteFields.entries.map((field) {
                  return CreatorVoteTile(field.value, votesMap[field.key] ?? 0);
                }).toList()),
            SizedBox(height: 20),
            Row(
              children: [
                if (voteRoom.resultsPosted == false)
                  OutlineButton(
                    child: Text('Post Results'),
                    onPressed: () async {
                      await showDialog(
                          context: (context),
                          builder: (ctx) => Alert(
                                title: 'Are You Sure?',
                                onAgree: () async {
                                  await voteRoom.postResults();
                                  Navigator.pop(context);
                                },
                                onCancel: () => Navigator.pop(context),
                                content:
                                    'Posting the results will make votes visible to all voters.\nVoting will be closed and no one can vote after posting results.',
                              ));
                      Utils.showSnack(
                          context: context,
                          content: 'Results posted successfully');
                    },
                  ),
                SizedBox(width: 10),
                OutlineButton(
                  onPressed: () {
                    showDialog(
                        context: (context),
                        builder: (ctx) => Alert(
                              title: 'Are You Sure?',
                              onAgree: () {
                                Navigator.of(context).pop();
                                voteRoom.closeRoom();
                              },
                              onCancel: () => Navigator.pop(context),
                              content:
                                  'You wont be able to access this room again after closing. The results will be shown to all voters and no new vote can be submitted.',
                            ));
                  },
                  child: Text('Close Room'),
                  borderSide: BorderSide(color: Colors.red),
                ),
                Spacer(),
                if (voteRoom.resultsPosted == false)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      child: isGettingResults
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomLoader(),
                            )
                          : IconButton(
                              icon: Icon(Icons.refresh_sharp),
                              onPressed: () async {
                                await getResults(voteRoom);
                              },
                            ),
                    ),
                  ),
              ],
            ),
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
//                  return Text(
//                      '${field.key}: ${field.value}-${snapshot.data.data()['votes'][field.key]}');
//                }).toList()),
//          ),
