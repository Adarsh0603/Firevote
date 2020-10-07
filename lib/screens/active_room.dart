import 'package:firevote/data/voteroom.dart';
import 'package:firevote/widgets/vote_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveRoom extends StatelessWidget {
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
              Text(voteRoom.roomDetails.creatorName),
            ],
          ),
          SizedBox(height: 20),
          Text(voteRoom.roomDetails.roomId),
          ...voteRoom.roomDetails.voteFields.entries.map((field) {
            return VoteTile(field.value, field.key);
          }).toList(),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'Close Room',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await voteRoom.closeRoom();
              },
            ),
          ),
        ],
      ),
    );
  }
}
