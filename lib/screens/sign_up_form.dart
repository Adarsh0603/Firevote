import 'package:firevote/constants.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String email;
  String password;
  TextEditingController passwordController = TextEditingController();

  void onFormSave() async {
    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Screen'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: kAuthFormInputDecoration.copyWith(hintText: 'Name'),
              onSaved: (value) {
                name = value;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: kAuthFormInputDecoration.copyWith(hintText: 'Email'),
              onSaved: (value) {
                password = value;
              },
            ),
            TextFormField(
              decoration:
                  kAuthFormInputDecoration.copyWith(hintText: 'Password'),
              onSaved: (value) {
                passwordController.text = value;
              },
            ),
            TextFormField(
              decoration: kAuthFormInputDecoration.copyWith(
                  hintText: 'Confirm Password'),
              onSaved: (value) {
                password = value;
              },
            ),
            FlatButton(
              child: Text('Sign Up'),
              onPressed: onFormSave,
            )
          ],
        ),
      ),
    );
  }
}
