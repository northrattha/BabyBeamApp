import 'package:BabyBeamApp/development.dart';
import 'package:BabyBeamApp/model/historyDev.dart';
import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'components/imageProfile.dart';
import 'components/modalDevHist.dart';
import 'model/babyInfo.dart';
import 'myStyle.dart';

class DevHistory extends StatefulWidget {
  @override
  _DevHistoryState createState() => _DevHistoryState();
}

class _DevHistoryState extends State<DevHistory> {
  String userID;
  Set<HistoryDev> mySet = new Set();
  Color primary = bage;
  List<HistoryDev> historydev = new List();
  double dotsize = 30;

  @override
  void initState() {
    super.initState();
    if (BabyInfo.devHist != null) {
      mySet = BabyInfo.devHist.toSet();
      historydev = mySet.toList();
    } else
      historydev = null;
    readData();
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
          .collection('/baby_profile/$userID/development_record')
          .orderBy("time", descending: true)
          .snapshots()
          .listen((event) {
        List<QueryDocumentSnapshot> snapshot = event.docs;
        if (snapshot.isNotEmpty) {
          // print('have');
        } else {
          print('No');
        }
      });
    });
  }

  String atAge(String date) {
    DateTime tempDate = new DateFormat("dd MMM y").parse(date);
    DateTime birthDate = new DateFormat("dd MMM y").parse(BabyInfo.birthDay);
    AgeDuration age2 =
        Age.dateDifference(fromDate:birthDate, toDate: tempDate );
    String year = "${age2.years} ปี";
    String month = "${age2.months} เดือน";
    String day = "${age2.days} วัน";

    if (age2.years == 0) {
      year = "";
    }
    if (age2.months == 0) {
      month = "";
    }
    if (age2.days == 0) {
      day = "";
    }
    String age = '$month $day';
    if (age2.years != 0) return age = '$year $month';
    // if(age2.years.isNegative&&age2.months.isNegative&&)
    if (age == " ") return age = "แรกเกิด";

    return age;
  }

  getHistory() async {
    if (BabyInfo.histID != null && BabyInfo.devHist != null) {
      BabyInfo.devhistID.clear();
      BabyInfo.devHist.clear();
    }
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
            // HistoryDev model = HistoryDev.fromMap(map);
            setState(() {
              BabyInfo.devhistID.add(snap["id"]);
            });
          });
        }
      } else {
        print('No History');
      }
    });
  }

  Widget timeLineBox(color, HistoryDev hist) {
    print('hist : ${atAge(hist.day)}');
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showGeneralDialog(
              // barrierDismissible: true, //กดบริเวณอื่นให้ออก
              context: context,
              pageBuilder: (context, _, __) {
                return ModalDevHistory(
                    colorbuttom: white,
                    colormodal: grayBackGroundColor,
                    histList: hist);
              },
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ).drive(Tween<Offset>(
                    begin: Offset(0, -1.0),
                    end: Offset.zero,
                  )),
                  child: child,
                );
              },
            );
          },
          child: new Container(
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
                    txtSmallHeader(hist.day, greyDark),
                    Text(
                      atAge(hist.day),
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(hist.name),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget indicatorNew(double dotsize, String key) {
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
            color: key == "วัคซีนเสริม" ? yelloMastard : nav,
          ),
        ),
      ],
    );
  }

  Widget timeLineDev() {
    return Container(
      width: 360,
      padding: EdgeInsets.only(left: 30),
      child: ListView.builder(
        itemCount: historydev.length,
        itemBuilder: (context, index) {
          final history0 = historydev;
          Color color = bluebeam01;
          String id = history0[index].id;
          return Container(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.2,
              child: SizedBox(
                child: checkIndex(color, index, historydev[index]),
              ),
              secondaryActions: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: redbeam,
                  ),
                  child: IconSlideAction(
                    color: Colors.transparent,
                    icon: Icons.delete,
                    onTap: () {
                      historydev.removeAt(index);
                      FirebaseFirestore.instance
                          .collection(
                              "/baby_profile/$userID/development_record")
                          .where("id", isEqualTo: id)
                          .get()
                          .then((snapshot) {
                        BabyInfo.devhistID.removeAt(index);
                        snapshot.docs.first.reference.delete().then((value) {
                          print("Remove Success");
                          setState(() {
                            getHistory();
                          });
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget checkIndex(Color color, int index, HistoryDev hist) {
    if (historydev.length == 1) {
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
              indicator: indicatorNew(20, hist.key), //30
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
              indicator: indicatorNew(20, hist.key), //30
              indicatorXY: 0.30,
              padding: EdgeInsets.only(right: 10),
              color: primary),
        ),
      );
    }
    if (index == (historydev.length - 1)) {
      return SizedBox(
        child: TimelineTile(
          alignment: TimelineAlign.start,
          endChild: timeLineBox(color, hist),
          isLast: true,
          beforeLineStyle: const LineStyle(thickness: 3),
          indicatorStyle: IndicatorStyle(
              width: 30,
              height: 30,
              indicator: indicatorNew(20, hist.key),
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
          indicator: indicatorNew(20, hist.key), //30
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
                  if (BabyInfo.devHist != null) {
                    BabyInfo.devHist.clear();
                  }
                  // Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Development()));
                },
              ),
              Text(
                'ทักษะและพัฒนาการ',
                style: TextStyle(fontSize: 20,),
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
      height: size.height*0.8,
      alignment: Alignment.center,
      child: Text('ไม่พบประวัติ',style: TextStyle(color: greyDark.withOpacity(0.3),fontSize: 15),),
    );
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
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
          BabyInfo.devHist != null
              ? Flexible(child: timeLineDev())
              : noData(),
        ],
      ),
    );
  }
}
