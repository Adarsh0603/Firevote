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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(joinedRoom.roomDetails.roomName),
              Text(joinedRoom.roomDetails.creatorName),
            ],
          ),
          SizedBox(height: 20),
          Text(joinedRoom.roomDetails.roomId ?? 'default'),
          ...joinedRoom.roomDetails.voteFields.entries.map((field) {
            return VoteTile(field.value, field.key);
          }).toList(),
          FlatButton(
            child: Text('LeaveRoom'),
            onPressed: () {
              joinedRoom.leaveRoom();
            },
          ),
        ],
      ),
    );
  }
}
