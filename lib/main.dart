import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:BabyBeamApp/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // var _primary = greenbeam;

  @override
  Widget build(BuildContext context) {
    User firebaseUser = FirebaseAuth.instance.currentUser;
    Widget firstWidget;

    if (firebaseUser != null) {
      firstWidget = Home();
    } else {
      firstWidget = SignIn();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: firstWidget,
      title: 'MyApp',
      theme: ThemeData(
        fontFamily: 'Medium',
        accentColor: white,
        scaffoldBackgroundColor: grayBackGroundColor,
      ),
    );
  }
}
