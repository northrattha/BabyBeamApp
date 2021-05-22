import 'package:BabyBeamApp/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DevService {
  String userID = Account.userID;
  getVacHistory() {
    return FirebaseFirestore.instance
        .collection('/baby_profile/${userID+'1'}/development_record')
        .orderBy('day')
        .get();
  }
}
