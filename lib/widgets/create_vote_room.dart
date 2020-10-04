import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/modals/votefield.dart';
import 'package:firevote/widgets/add_field_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateVoteRoom extends StatefulWidget {
  @override
  _CreateVoteRoomState createState() => _CreateVoteRoomState();
}

class _CreateVoteRoomState extends State<CreateVoteRoom> {
  List<VoteField> inputList = [];
  final _formKey = GlobalKey<FormState>();
  String roomName;
  void onFormSave() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    await Provider.of<VoteRoom>(context, listen: false)
        .createVoteRoom(roomName);
  }

  void addField() {
    setState(() {
      inputList.add(VoteField(fieldName: 'Vote Field ${inputList.length + 1}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Vote Room'),
            TextFormField(
              validator: (value) {
                if (value.isEmpty)
                  return 'Please enter room name.';
                else
                  return null;
              },
              decoration: kRoomFormInputDecoration,
              onSaved: (value) {
                roomName = value;
              },
            ),
            Expanded(
              child: ListView(
                children: List.generate(inputList.length, (index) {
                  return TextFormField(
                    decoration:
                        InputDecoration(hintText: inputList[index].fieldName),
                    onSaved: (value) {
                      inputList[index].fieldValue = value;
                    },
                  );
                }),
              ),
            ),
            AddFieldButton(onPressed: addField),
            SizedBox(height: 10),
            Center(
              child: FlatButton(
                color: kPrimaryColor,
                child: Text('Create Room'),
                onPressed: onFormSave,
              ),
            )
          ],
        ),
      ),
    );
  }
}
