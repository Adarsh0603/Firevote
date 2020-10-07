import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/modals/votefield.dart';
import 'package:firevote/widgets/add_field_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateVoteRoom extends StatefulWidget {
  @override
  _CreateVoteRoomState createState() => _CreateVoteRoomState();
}

class _CreateVoteRoomState extends State<CreateVoteRoom> {
  List<VoteField> inputList = [
    VoteField(fieldName: 'Vote Field 1'),
    VoteField(fieldName: 'Vote Field 2')
  ];
  final _formKey = GlobalKey<FormState>();
  String roomName;

  void onFormSave() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    Map<String, String> voteFields = Map.fromIterable(inputList,
        key: (e) => e.fieldName, value: (e) => e.fieldValue);
    await Provider.of<VoteRoom>(context, listen: false)
        .createVoteRoom(roomName, voteFields);
    Navigator.pop(context);
  }

  void addField() {
    setState(() {
      inputList.add(VoteField(fieldName: 'Vote Field ${inputList.length + 1}'));
    });
  }

  void removeField() {
    setState(() {
      inputList.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//            Text('Create Vote Room', style: kHeadingTextStyle),
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
            SizedBox(height: 20),
            Text('Enter Vote Fields', style: kHeadingTextStyle),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: List.generate(inputList.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Material(
                      elevation: 2,
                      child: TextFormField(
                        validator: (value) => value.isEmpty
                            ? 'Vote field cannot be empty!'
                            : null,
                        decoration: InputDecoration(
                            hintText: inputList[index].fieldName,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 8)),
                        onSaved: (value) {
                          inputList[index].fieldValue = value;
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  CustomIconButton(
                    onPressed: inputList.length <= 2 ? null : removeField,
                    iconData: Icons.remove,
                  ),
                  CustomIconButton(
                    onPressed: inputList.length >= 6 ? null : addField,
                    iconData: Icons.add,
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text('Create Room'),
                    onPressed: onFormSave,
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
