import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReadInfo extends StatelessWidget {
  

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final databaseReference = FirebaseFirestore.instance;
  String nickname = '...';
  String userID;

  void initState() {
    readData();
  }

  Future<void> readData() async {
    getUser();
    DocumentSnapshot info = await FirebaseFirestore.instance
        .collection('baby_profile')
        .doc(userID)
        .get();

      nickname = info.get('nickname');

  }

  Future<void> getUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    ;
    userID = user.uid;
  }



  @override
  Widget build(BuildContext context) {
    
  }
}
