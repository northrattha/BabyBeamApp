import 'package:BabyBeamApp/model/HeadCircum.dart';
import 'package:BabyBeamApp/model/bmi.dart';
import 'package:BabyBeamApp/model/develop.dart';
import 'package:BabyBeamApp/model/graphSympHist.dart';
import 'package:BabyBeamApp/model/historyDev.dart';
import 'package:BabyBeamApp/model/historyVac.dart';
import 'package:BabyBeamApp/model/user.dart';
import 'package:BabyBeamApp/model/weighHist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'heightHist.dart';

class BabyInfo {
  static String userID;
  static String firstname = '...';
  static String lastname = '...';
  static String nickname = '...';
  static String sex = '...';
  static String birthDay = '...';
  static String ageRange = '...';
  static String devRange = '...';
  static int ageY, ageM, ageD;
  static var age;
  // Vaccine
  static List<HistoryVac> vacHist;
  static List<String> histID = new List();
  // Develop
  static List<Develop> devList = new List();
  static List<HistoryDev> devHist = new List();
  static List<String> devhistID = new List();
  // analize
  static List<GraphSympHist> graphSympHist = new List();
  static List<HeightHist> heightHist = new List();
  static List<WeighHist> weighHist = new List();
  static List<HeadCirCum> headCircumHist = new List();
  static List<BMI> bmiHist = new List();


   String findAge() {
    String year = "";
    String month = "";
    String day = "";
    if (ageY != 0 || ageM != 0 || ageD != 0) {
      if (ageY != 0) {
        year = "${ageY} ปี";
      }
      if (ageM != 0) {
        month = " ${ageM} เดือน";
      }
      if (ageD != 0) {
        day = " ${ageD} วัน";
      }
      return "$year$month$day";
    } else
      return "แรกเกิด";
  }

  Future<void> readData() async {
    print('BabyInfo readData ...');
    Account().getUserID();
    userID = Account.userID;
    print("UserId : $userID");
    DocumentSnapshot info = await FirebaseFirestore.instance
        .collection('baby_profile')
        .doc(userID)
        .get();
    print('BabyInfo : ${info.get('nickname')}');
    ageY = info.get('ageY');
    ageM = info.get('ageM');
    ageD = info.get('ageD');
    firstname = info.get('first_name');
    lastname = info.get('last_name');
    nickname = info.get('nickname');
    sex = info.get('sex');
    birthDay = info.get('birthDate');
    age = double.parse("$ageY.$ageM");
  }
}
