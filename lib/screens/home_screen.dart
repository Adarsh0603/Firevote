import 'package:firevote/data/voteroom.dart';
import 'package:firevote/screens/active_room.dart';
import 'package:firevote/screens/joined_room.dart';
import 'package:firevote/widgets/app_drawer.dart';
import 'package:firevote/widgets/create_join_room.dart';
import 'package:firevote/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar.getAppBar(context, 'Firevote'),
      body: FutureBuilder(
        future: Provider.of<VoteRoom>(context, listen: false).getActiveRoom(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<VoteRoom>(
                    builder: (ctx, room, _) {
                      return room.roomDetails != null
                          ? room.roomDetails.creatorId == room.user.uid
                              ? ActiveRoom()
                              : JoinedRoom()
                          : CreateJoinRoom();
                    },
                  ),
      ),
    );
  }
}
