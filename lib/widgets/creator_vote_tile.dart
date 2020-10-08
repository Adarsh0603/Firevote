import 'package:firevote/data/voteroom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatorVoteTile extends StatefulWidget {
  final String title;
  final int votes;

  CreatorVoteTile(this.title, this.votes);

  @override
  _CreatorVoteTileState createState() => _CreatorVoteTileState();
}

class _CreatorVoteTileState extends State<CreatorVoteTile> {
  List voterList = [];
  bool isExpanded = false;
  void getVotersList() {
    if (isExpanded) {
      setState(() {
        isExpanded = false;
      });
      return;
    }
    final currentDoc = Provider.of<VoteRoom>(context, listen: false).currentDoc;
    List voters = currentDoc.data()['voted'] as List;
    List selectedVotersList = [];
    voters.forEach((voter) {
      if (voter['voteTo'] == widget.title) {
        selectedVotersList.add(voter);
      }
    });
    setState(() {
      voterList = selectedVotersList;
      isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: getVotersList,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                      '${widget.votes} ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Votes',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  Divider(),
                  Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.only(left: 8, top: 8),
                    height: 100,
                    child: ListView.builder(
                        itemBuilder: (ctx, i) => Text(
                            '${voterList[i]['name']} -${voterList[i]['email']}'),
                        itemCount: voterList.length),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
