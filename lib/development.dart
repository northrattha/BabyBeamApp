import 'package:BabyBeamApp/components/modalAddDev.dart';
import 'package:BabyBeamApp/devHistory.dart';
import 'package:BabyBeamApp/model/develop.dart';
import 'package:BabyBeamApp/model/historyDev.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/imageProfile.dart';
import 'home.dart';
import 'model/babyInfo.dart';
import 'model/user.dart';
import 'myStyle.dart';

class Development extends StatefulWidget {
  @override
  _DevelopmentState createState() => _DevelopmentState();
}

class _DevelopmentState extends State<Development> {
  int ageD;
  List<Develop> devList = new List();
  List histID = ["VGa7zht8un1HwqC436Sa", "zDXCgoxgDdrM8tyihcke"];
  List<HistoryDev> hisdev = new List();
  Color primaryButton = grayShadowColor;

  @override
  void initState() {
    print('Dev Year Range : ${BabyInfo.devRange}');
    super.initState();
    readData();
    getHistory();
  }

  Future<void> readData() async {
    FirebaseFirestore.instance
        .collection('/development/${BabyInfo.devRange}/devel')
        .snapshots()
        .listen((event) {
      List<QueryDocumentSnapshot> snapshot2 = event.docs;
      if (snapshot2.isNotEmpty) {
        for (var snap in snapshot2) {
          Map<String, dynamic> map = snap.data();
          map["id"] = snap.id;
          Develop model = Develop.fromMap(map);
          // print(model);
          setState(() {
            // importent
            devList.add(model);
          });
        }
      } else {
        print('No Dev');
                readData();

      }
    });
  }

  Future<void> getHistory() async {
    String userID = Account.userID;
    FirebaseFirestore.instance
        .collection('/baby_profile/$userID/development_record')
        .orderBy("time", descending: true)
        .snapshots()
        .listen((event) {
      List<QueryDocumentSnapshot> snapshot2 = event.docs;
      if (snapshot2.isNotEmpty) {
        for (var snap in snapshot2) {
          setState(() {
            // importent
            Map<String, dynamic> map = snap.data();
            HistoryDev model = HistoryDev.fromMap(map);
            hisdev.add(model);
            BabyInfo.devhistID.add(snap["id"]);
          });
        }
        BabyInfo.devHist = hisdev;
      } else {
        print('No History');
      }
    });
  }

  Widget buttonList(int index, HistoryDev filtered) {
    return RaisedButton(
      padding: EdgeInsets.all(20),
      color: BabyInfo.devhistID.contains(devList[index].id) ? bage : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(devList[index].key),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: 190,
            child: Text(devList[index].name),
          ),
        ],
      ),
      onPressed: () {
        print('Click');
        showGeneralDialog(
          // barrierDismissible: true, // click outsider to leave
          context: context,
          pageBuilder: (context, _, __) {
            return ModalDevelop(
                colorbuttom: white,
                colormodal: grayBackGroundColor,
                devList: devList[index],
                histList: filtered);
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ).drive(
                Tween<Offset>(
                  begin: Offset(0, -1.0),
                  end: Offset.zero,
                ),
              ),
              child: child,
            );
          },
        );
      },
    );
  }

  HistoryDev histIndex;

  Widget buildList() {
    return ListView.builder(
      itemCount: devList.length,
      itemBuilder: (context, index) {
        String id = devList[index].id;
        // print(BabyInfo.devHist);
        if (BabyInfo.devHist != null) {
          var filter =
              BabyInfo.devHist.where((content) => content.id == id).toList();
          histIndex = filter.asMap()[0];
        }

        return Container(
          padding: EdgeInsets.only(top: 15, left: 50, right: 50),
          child: buttonList(index, histIndex),
        );
      },
    );
  }

  Widget contentVaccine() {
    return Container(
      padding: EdgeInsets.only(top: 105),
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
            child: buildList(),
          ),
        ],
      ),
    );
  }

  Widget headInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 130,
      ),
      child: Column(
        children: [
          ImageProfile(
            size: 100.0, //100.0
            color: nav,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: white,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  BabyInfo.nickname,
                  style: TextStyle(
                      color: Colors.grey.shade800, fontFamily: 'Bold'),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(BabyInfo().findAge()),
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

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryButton,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: nav,
                // size: 20,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
          ),
        ),
        SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryButton,
            ),
            child: IconButton(
              icon: Icon(
                Icons.bookmark,
                color: nav,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DevHistory()));
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bage,
      body: SizedBox(
        height: 825,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              color: grayBackGroundColor,
              padding: EdgeInsets.only(top: 80),
              child: Mystyle().textButtonHeadbar('พัฒนาการ'),
            ),
            Positioned.fill(
              top: 200, // white site 200
              child: contentVaccine(),
            ),
            headInfo(),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              alignment: Alignment.bottomRight,
            ),
            appBar(),
          ],
        ),
      ),
    );
  }
}
