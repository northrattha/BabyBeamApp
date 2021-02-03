import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:BabyBeamApp/components/imageProfile.dart';
import 'package:BabyBeamApp/vaccineHistory.dart';
import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'components/BackButtonBeam.dart';
// import 'unility/DB.dart';
import 'components/BottonNavBar.dart';

class Vaccine extends StatefulWidget {
  @override
  _VaccineState createState() => _VaccineState();
}

class _VaccineState extends State<Vaccine> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final databaseReference = FirebaseFirestore.instance;
  String nickname = '...';
  String userID;
  String birthDate = '...';
  int ageY, ageM, ageD;
  DateTime date;
  List<String> vaccineForAge;
  String key = '...';

  CollectionReference vaccine =
      FirebaseFirestore.instance.collection("Vaccine");

  @override
  void initState() {
    super.initState();
    readData();
  }

  Widget vaccineList() {
    // var oo = FirebaseFirestore.instance.collection("Vaccine").where('startAge', isLessThanOrEqualTo: '${ageY}Y ${ageM}M');
    // // print('me : $ageY , $ageM');
    // vaccine.where('startAge', isLessThanOrEqualTo: '${ageY}Y ${ageM}M');
    // vaccine.where('endAge', isGreaterThan: '1.6');
    return StreamBuilder(
      stream: vaccine
          .where('startAge', isLessThanOrEqualTo: '0.1')
          // .where('startAge', isLessThanOrEqualTo: '${ageY}.${ageM}')
          .snapshots(),
      builder: buildList,
    );
  }

  Widget buildList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      print('has');
      return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot user = snapshot.data.docs[index];
            // var end = user.get('endAge');
            // var cut = end.split('.');
            // int endY = int.parse(cut[0]);
            // int endM = int.parse(cut[1]);
            // double w = double.parse(end);
            // double a = double.parse('${ageY}.$ageM');

            // print(w);
            // if (endY > ageY || (endY == ageY && endM > ageM)) {
            // if (w > a) {
            //   print('$ageY kgg $endY');
            //   // buttonVaccine(
            //   //   user.get('key'),
            //   //   user.get('name'),
            //   // );
            //    return buttonVaccine(
            //   user.get('key'),
            //   user.get('name'),
            // );
            // }
            return buttonVaccine(
              user.get('key'),
              user.get('name'),
            );
          }
          // }
          );
    }
    return Text('No Data');
  }
  // var data = new ReadInfo();

  Future<void> readData() async {
    getUser();
    DocumentSnapshot info = await FirebaseFirestore.instance
        .collection('baby_profile')
        .doc(userID)
        .get();
    setState(() {
      ageY = info.get('ageY');
      ageM = info.get('ageM');
      ageD = info.get('ageD');
      nickname = info.get('nickname');
    });
  }

  Future<void> getUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    ;
    userID = user.uid;
  }

  Widget HeadInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        // top: 150,
        top: 130,
      ),
      child: Column(
        children: [
          ImageProfile(
            size: 100.0,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: white,
            // padding: EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  nickname,
                  style: TextStyle(
                      color: Colors.grey.shade800, fontFamily: 'Bold'),
                ),
                SizedBox(
                  height: 5,
                ),
                (ageY == 0 && ageM == 0 && ageD == 0)
                    ? Text('แรกเกิด')
                    : Text('${ageY} ปี ${ageM} เดือน'),
                // Text((() {
                //   if (ageY==0 && ageM==0 && ageD==0) {
                //     return 'แรกเกิด';
                //   }else{
                //      return 'สำหรับช่วงอายุ ${ageY} ปี ${ageM} เดือน';
                //   }
                // })()),
                // 'สำหรับช่วงอายุ ${ageY} ปี ${ageM} เดือน'
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addOtherVaccine() {
    // return Container(
    //   padding: EdgeInsets.only(top: 50),
    //   width: 50,
    //   height: 50,
    //   child: RaisedButton(
    //     padding: EdgeInsets.zero,
    //     shape: CircleBorder(),
    //     color: Colors.black,
    //     onPressed: () {},
    //     child: Icon(
    //       Icons.add_rounded,
    //       color: greenbeam,
    //       size: 40,
    //     ),
    //   ),
    // );
    return Container(
      width: 60,
      height: 60,
      child: RaisedButton(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VaccinHistory()),
          );
        },
        color: white,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(15),
        //     bottomLeft: Radius.circular(15),
        //   ),
        // ),
        child: Icon(
          Icons.add_rounded,
          color: greenbeam,
          size: 40,
        ),
      ),
    );
  }

  Widget vaccineHistory() {
    return RaisedButton(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VaccinHistory()),
        );
      },
      color: orangeButtonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      child: Text(
        'ประวัติการรับวัคซีน',
        style: TextStyle(
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget buttonVaccine(String key, String name) {
    print('CreateB');
    return Container(
      padding: EdgeInsets.only(top: 15, left: 50, right: 50),
      child: RaisedButton(
        padding: EdgeInsets.all(20),
        onPressed: () {},
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(key),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 190,
              child: Text(name),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentVaccine() {
    return Container(
// color: bluePastel,
      padding: EdgeInsets.only(top: 100),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          Flexible(
            child: vaccineList(),
          ),
          SizedBox(
            height: 20,
          ),
          addOtherVaccine(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: 825,
        child: Stack(
          children: [
            Container(
              // height: 300,
              alignment: Alignment.topCenter,
              width: double.infinity,
              color: purpleBackGroundColor,
              padding: EdgeInsets.only(top: 80),
              child: Mystyle().TextButtonHeadbar('Vaccine'),
            ),
            Positioned.fill(
              top: 200,
              child: contentVaccine(),
            ),
            HeadInfo(),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              alignment: Alignment.bottomRight,
              child: vaccineHistory(),
            ),
            // BackButton(),
            BackButtonBeam(background: purpleBackGroundColor),
            // modalFormTop(),
          ],
        ),
      ),
      bottomNavigationBar: BottonNavBar(
        titleBottomNavBar: 'Home',
        context: context,
      ),
    );
  }
}
