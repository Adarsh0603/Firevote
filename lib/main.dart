import 'package:firebase_core/firebase_core.dart';
import 'package:firevote/constants.dart';
import 'package:firevote/data/auth.dart';
import 'package:firevote/data/voteroom.dart';
import 'package:firevote/screens/splash_screen.dart';
import 'package:firevote/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (BuildContext context) => Auth()),
        ChangeNotifierProxyProvider<Auth, VoteRoom>(
          create: (BuildContext context) => VoteRoom(),
          update: (BuildContext context, auth, voteRoom) => voteRoom..update(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:
              ThemeData(primaryColor: kPrimaryColor, accentColor: kAccentColor),
          title: 'FireVote',
          home: FutureBuilder(
            future: _initialization,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? SplashScreen()
                  : Wrapper();
            },
          )),
    );
  }
}
