import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/utils.dart';
import 'package:firevote/widgets/voter_detail.dart';
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
    if (currentDoc == null) {
      Utils.showSnack(context: context, content: 'No Votes yet');
      return;
    }
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
        padding: const EdgeInsets.all(4.0),
        child: Material(
          elevation: isExpanded ? 5 : 2,
          color: Colors.white,
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
                      style: kVoterNameTextStyle,
                    ),
                    Spacer(),
                    Text(
                      '${widget.votes} ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.green),
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
                    height: 100,
                    child: ListView.builder(
                        itemBuilder: (ctx, i) => Container(
                              child: VoterDetail(voterList[i]['name'],
                                  voterList[i]['email'], i),
                            ),
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
