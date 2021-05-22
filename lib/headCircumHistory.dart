import 'package:BabyBeamApp/healthHeadCircumference.dart';
import 'package:BabyBeamApp/model/HeadCircum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'components/imageProfile.dart';
import 'model/babyInfo.dart';
import 'myStyle.dart';

class HeadCircumHistory extends StatefulWidget {
  @override
  _HeadCircumHistoryState createState() => _HeadCircumHistoryState();
}

class _HeadCircumHistoryState extends State<HeadCircumHistory> {
  String userID;
  Set<HeadCirCum> mySet = new Set();
  Color primary = bage;
  List<HeadCirCum> historyheigh = [];
  double dotsize = 30;
  List<HeadCirCum> hisdev = new List();

  @override
  void initState() {
    super.initState();
    readData();
    getHistory();

    print(BabyInfo.headCircumHist);
    if (BabyInfo.headCircumHist != null) {
      mySet = BabyInfo.headCircumHist.toSet();
      setState(() {
        historyheigh = mySet.toList();
      });
    } else
      historyheigh = [];
  }

  Future<void> getHistory() async {
    print('getHistttt');
    // String userID = Account.userID;
    FirebaseFirestore.instance
        .collection('/baby_profile/${BabyInfo.userID}/headCircum_history')
        .orderBy("time", descending: true)
        .snapshots()
        .listen((event) {
      List<QueryDocumentSnapshot> snapshot2 = event.docs;
      if (snapshot2.isNotEmpty) {
        for (var snap in snapshot2) {
          setState(() {
            // importent
            Map<String, dynamic> map = snap.data();
            HeadCirCum model = HeadCirCum.fromMap(map);
            hisdev.add(model);
          });
        }
        BabyInfo.headCircumHist = hisdev;
        print('object : ${BabyInfo.headCircumHist}');
      } else {
        print('No History');
      }
    });
  }

  Future<void> getUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    userID = user.uid;
  }

  Future<Null> readData() async {
    getUser();
    await Firebase.initializeApp().then((value) async {
      print('initialize success');
      FirebaseFirestore.instance
          .collection('/baby_profile/${BabyInfo.userID}/headCirCum_history')
          .orderBy("time", descending: true)
          .snapshots()
          .listen((event) {
        List<QueryDocumentSnapshot> snapshot2 = event.docs;
        if (snapshot2.isNotEmpty) {
          for (var snap in snapshot2) {
            Map<String, dynamic> map = snap.data();
            map["id"] = snap.id;
            HeadCirCum model = HeadCirCum.fromMap(map);
            // print(model);
            setState(() {
              // importent
              BabyInfo.headCircumHist.add(model);
            });
          }
        } else {
          print('No');
        }
      });
    });
  }

  Widget timeLineBox(color, HeadCirCum hist) {
    // print('hist : ${atAge(hist.day)}');
    return Column(
      children: [
        new Container(
            margin: EdgeInsets.only(bottom: 25),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                // color: bluebeam01
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                // color: hist.key == "วัคซีนเสริม" ? color : greenBackGroundColor,
                color: grayBackGroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    txtSmallHeader('${hist.headCirCum} ซม.', greyDark),
                    Text(
                     hist.date ,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
          ),
        
      ],
    );
  }

  Widget indicatorNew(double dotsize) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: dotsize,
          // height: ,
          decoration: BoxDecoration(
            border: Border.all(color: purple, width: 3),
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: yellowPastel,
            color: cadetBlueCrayola,
          ),
        ),
      ],
    );
  }

  Widget timeLine() {
    print('Line : ${BabyInfo.headCircumHist}');
    return Container(
      width: 360,
      padding: EdgeInsets.only(left: 30),
      child: ListView.builder(
        itemCount: BabyInfo.headCircumHist.toSet().length,
        itemBuilder: (context, index) {
          mySet=BabyInfo.headCircumHist.toSet();
          historyheigh = mySet.toList();
          Color color = bluebeam01;
          // String id = history0[index].id;
          return Container(
            child: SizedBox(
              child: checkIndex(color, index, historyheigh[index]),
            ),
          );
        },
      ),
    );
  }

  Widget checkIndex(Color color, int index, HeadCirCum hist) {
    if (historyheigh.length == 1) {
      print('hrer');
      return SizedBox(
        child: TimelineTile(
          alignment: TimelineAlign.start,
          endChild: timeLineBox(color, hist),
          isFirst: true,
          isLast: true,
          // beforeLineStyle: const LineStyle(thickness: 3),
          indicatorStyle: IndicatorStyle(
              width: 30,
              height: 30,
              indicator: indicatorNew(20), //30
              indicatorXY: 0.30,
              padding: EdgeInsets.only(right: 10),
              color: primary),
        ),
      );
    }

    if (index == 0) {
      return SizedBox(
        child: TimelineTile(
          alignment: TimelineAlign.start,
          endChild: timeLineBox(color, hist),
          isFirst: true,
          beforeLineStyle: const LineStyle(thickness: 3),
          indicatorStyle: IndicatorStyle(
              width: 30,
              height: 30,
              indicator: indicatorNew(20), //30
              indicatorXY: 0.30,
              padding: EdgeInsets.only(right: 10),
              color: primary),
        ),
      );
    }
    if (index == (historyheigh.length - 1)) {
      return SizedBox(
        child: TimelineTile(
          alignment: TimelineAlign.start,
          endChild: timeLineBox(color, hist),
          isLast: true,
          beforeLineStyle: const LineStyle(thickness: 3),
          indicatorStyle: IndicatorStyle(
              width: 30,
              height: 30,
              indicator: indicatorNew(20),
              indicatorXY: 0.30,
              padding: EdgeInsets.only(right: 10),
              color: purple),
        ),
      );
    }
    return SizedBox(
      child: TimelineTile(
        alignment: TimelineAlign.start,
        endChild: timeLineBox(color, hist),
        beforeLineStyle: const LineStyle(
          thickness: 3,
        ),
        indicatorStyle: IndicatorStyle(
          width: 30,
          height: 30,
          indicatorXY: 0.30,
          indicator: indicatorNew(20), //30
          padding: EdgeInsets.only(right: 10),
        ),
      ),
    );
  }

  Widget headbar() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: white,
                ),
                onPressed: () {
                  if (BabyInfo.headCircumHist != null) {
                    BabyInfo.headCircumHist.clear();
                  }
                  // Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HealthHeadCircumference()));
                },
              ),
              Text(
                'รอบศีรษะ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              ImageProfile(
                size: 5,
                color: bage,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget noData() {
    return Container(
      height: size.height * 0.8,
      alignment: Alignment.center,
      // color: redBurgandy,
      child: Text(
        'ไม่พบประวัติ',
        style: TextStyle(color: greyDark.withOpacity(0.3), fontSize: 15),
      ),
    );
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    print('object build  : ${BabyInfo.headCircumHist}');
    size = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: bage,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            // height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(35),
                  bottomLeft: Radius.circular(35)),
              color: primary,
              // color: nav,
            ),
            child: SafeArea(
              child: headbar(),
            ),
          ),
          BabyInfo.headCircumHist != null
              ? Flexible(child: timeLine())
              : noData(),
        ],
      ),
    );
  }
}
