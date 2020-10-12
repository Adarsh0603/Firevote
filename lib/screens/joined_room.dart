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
                IconButton(
                    onPressed: () => joinedRoom.leaveRoom(),
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    )),
              ],
            ),
            SizedBox(height: 20),
            ...joinedRoom.roomDetails.voteFields.entries.map((field) {
              bool wasSelected = joinedRoom.checkVotedField(field.value);
              return VoteTile(
                  field.value, field.key, wasSelected, hasAlreadyVoted);
            }).toList(),
            SizedBox(height: 20),
            Text('Results', style: kResultsTextStyle),
            if (joinedRoom.currentDoc.data()['postResults'] == false)
              Text('Not posted yet.', style: kResultsWaitingTextStyle),
            if (joinedRoom.currentDoc.data()['postResults'] == true) ...[
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 2,
                  child: Container(
                    width: double.infinity,
                    child: DataTable(
                      dividerThickness: 0.0,
                      sortAscending: false,
                      columns: [
                        DataColumn(numeric: false, label: Text('Field')),
                        DataColumn(label: Text('Votes')),
                      ],
                      rows: joinedRoom.voteResults(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ]
          ],
        ),
      ),
    );
  }
}
