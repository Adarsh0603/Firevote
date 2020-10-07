import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/widgets/vote_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinedRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final joinedRoom = Provider.of<VoteRoom>(context, listen: false);
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
              return VoteTile(field.value, field.key);
            }).toList(),
          ],
        ),
      ),
    );
  }
}
