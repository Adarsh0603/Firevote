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
      child: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.blue[600],
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
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
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        color: Colors.blue[300],
                        child: Text(
                          'Invite',
                          style: kWhiteText,
                        ),
                        onPressed: () => Utils.shareId(
                            voteRoom.roomDetails.roomId,
                            voteRoom.roomDetails.roomName),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding:
                    EdgeInsets.only(top: 16, bottom: 48, left: 16, right: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        voteRoom.roomDetails.voteFields.entries.map((field) {
                      return CreatorVoteTile(
                          field.value, votesMap[field.key] ?? 0);
                    }).toList()),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: voteRoom.resultsPosted
              ? Container(
                  width: double.infinity,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Text('Close Room', style: kWhiteText),
                    color: Colors.red,
                    onPressed: voteRoom.closeRoom,
                  ),
                )
              : Material(
                  elevation: 0,
                  color: Colors.grey[100],
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              'Post Results',
                              style: kWhiteText,
                            ),
                            color: Colors.blue[400],
                            onPressed: () async {
                              bool result = await showDialog(
                                  context: (context),
                                  builder: (ctx) => Alert(
                                        title: 'Release Results?',
                                        onAgree: () async {
                                          await voteRoom.postResults();
                                          Navigator.of(context).pop(true);
                                        },
                                        onCancel: () =>
                                            Navigator.of(context).pop(false),
                                        content:
                                            'Posting the results will make votes visible to all voters.\nVoting will be closed and no one can vote after posting results.',
                                      ));
                              if (result)
                                Utils.showSnack(
                                    context: context,
                                    content: 'Results posted successfully');
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: (context),
                                  builder: (ctx) => Alert(
                                        title: 'Close Room?',
                                        onAgree: () {
                                          Navigator.of(context).pop();
                                          voteRoom.closeRoom();
                                        },
                                        onCancel: () => Navigator.pop(context),
                                        content:
                                            'You wont be able to access this room again after closing. The results will be shown to all voters and no new vote can be submitted.',
                                      ));
                            },
                            icon: Icon(Icons.exit_to_app),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ]),
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
