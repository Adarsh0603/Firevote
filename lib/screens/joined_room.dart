import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/widgets/vote_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinedRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final joinedRoom = Provider.of<VoteRoom>(context, listen: false);
    bool hasAlreadyVoted = joinedRoom.hasAlreadyVoted;
    return Container(
      child: SingleChildScrollView(
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
                      Text(joinedRoom.roomDetails.roomName,
                          style: kRoomNameTextStyle),
                      Text(
                        'ID - ${joinedRoom.roomDetails.roomId ?? 'default'}',
                        style: kRoomIdTextStyle,
                      ),
                      Text('Created By-${joinedRoom.roomDetails.creatorName}',
                          style: kRoomCreatorTextStyle),
                    ],
                  ),
                  FlatButton(
                      onPressed: () async => await joinedRoom.leaveRoom(),
                      child: Text('Leave Room', style: kWhiteText)),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (joinedRoom.currentDoc.data()['postResults'] == false)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Material(
                  elevation: 0,
                  shadowColor: Colors.blue[500],
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue[100])),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                      child: Column(
                          children: joinedRoom.roomDetails.voteFields.entries
                              .map((field) {
                        bool wasSelected =
                            joinedRoom.checkVotedField(field.value);
                        return VoteTile(field.value, field.key, wasSelected,
                            hasAlreadyVoted);
                      }).toList())),
                ),
              ),
            SizedBox(height: 5),
            if (joinedRoom.currentDoc.data()['postResults'] == true)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Material(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16),
                        child: Text('Results :', style: kResultsTextStyle),
                      ),
                      Divider(height: 0),
                      if (joinedRoom.currentDoc.data()['postResults'] == false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Not posted yet.',
                              style: kResultsWaitingTextStyle),
                        ),
                      if (joinedRoom.currentDoc.data()['postResults'] ==
                          true) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 0,
                            child: Container(
                              color: Colors.grey[200],
                              width: double.infinity,
                              child: DataTable(
                                dividerThickness: 0.0,
                                sortAscending: false,
                                columns: [
                                  DataColumn(label: Text('Field')),
                                  DataColumn(label: Text('Votes')),
                                ],
                                rows: joinedRoom.voteResults(context),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 20),
                      ]
                    ],
                  ),
                ),
              ),
            if (joinedRoom.currentDoc.data()['postResults'] == false) ...[
              SizedBox(height: 30),
              Center(
                  child: Text(
                'Results are not posted yet.',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey),
              ))
            ]
          ],
        ),
      ),
    );
  }
}
