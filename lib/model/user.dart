import 'package:firebase_auth/firebase_auth.dart';

class Account {
  static String userID, userEmail;

  Future<void> getUserID() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    userID = user.uid;
    // return user.uid.toString();
  }

  Future<void> getUserEmail() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    userEmail = user.email;

    // return user.email;
  }
}
