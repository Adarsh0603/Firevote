import 'package:firevote/constants.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/modals/votefield.dart';
import 'package:firevote/widgets/custom_icon_button.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Create Vote Room'),
        actions: [
          FlatButton(
            child: Text(
              'Create',
              style: TextStyle(color: Colors.green),
            ),
            onPressed: onFormSave,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey[100],
                  child: TextFormField(
                    cursorColor: Colors.black,
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
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '  Enter Votefields',
                        style: kHeadingTextStyle,
                      ),
                      Spacer(),
                      CustomIconButton(
                        onPressed: inputList.length <= 2 ? null : removeField,
                        iconData: Icons.remove,
                      ),
                      CustomIconButton(
                        onPressed: inputList.length >= 10 ? null : addField,
                        iconData: Icons.add,
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                Material(
                  elevation: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: EdgeInsets.only(top: 2),
                    child: ListView(
                      children: List.generate(inputList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 4),
                          child: Material(
                            elevation: 4,
                            shadowColor: Colors.white,
                            color: Colors.blue[200],
                            child: TextFormField(
                              cursorColor: Colors.white,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              validator: (value) => value.isEmpty
                                  ? 'Vote field cannot be empty!'
                                  : null,
                              decoration: InputDecoration(
                                  hintText: inputList[index].fieldName,
                                  hintStyle: TextStyle(color: Colors.white),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
