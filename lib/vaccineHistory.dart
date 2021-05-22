import 'package:BabyBeamApp/components/imageProfile.dart';
import 'package:BabyBeamApp/components/modalHistory.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/historyVac.dart';
import 'package:BabyBeamApp/vaccine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'myStyle.dart';

class VaccinHistory extends StatefulWidget {
  @override
  _VaccinHistoryState createState() => _VaccinHistoryState();
}

class _VaccinHistoryState extends State<VaccinHistory> {
  String userID;
  List<HistoryVac> history = new List();
  Set<HistoryVac> mySet = new Set();
  Color primary = bage;
  Size size;

  @override
  void initState() {
    super.initState();
    if (BabyInfo.vacHist != null) {
      mySet = BabyInfo.vacHist.toSet();
      history = mySet.toList();
    } else
      history = null;
    readData();
  }

  getHistory() async {
    if (BabyInfo.histID != null && BabyInfo.vacHist != null) {
      BabyInfo.histID.clear();
      BabyInfo.vacHist.clear();
    }
    FirebaseFirestore.instance
        .collection('/baby_profile/$userID/vaccine_record')
        .orderBy("time", descending: true)
        .snapshots()
        .listen((event) {
      List<QueryDocumentSnapshot> snapshot2 = event.docs;
      if (snapshot2.isNotEmpty) {
        for (var snap in snapshot2) {
          setState(() {
            // importent
            Map<String, dynamic> map = snap.data();
            // HistoryVac model = HistoryVac.fromMap(map);
            setState(() {
              BabyInfo.histID.add(snap["id"]);
            });
          });
        }
        print("HisList in Hist : ${BabyInfo.histID.toSet()}");
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
          .collection('/baby_profile/$userID/vaccine_record')
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

  double dotsize = 30;
  Widget checkIndex(Color color, int index, HistoryVac hist) {
    if (history.length == 1) {
      print('hrer');
      return SizedBox(
        child: TimelineTile(
          alignment: TimelineAlign.start,
          endChild: timelineBox(color, hist),
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
          endChild: timelineBox(color, hist),
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
    if (index == (history.length - 1)) {
      return SizedBox(
        child: TimelineTile(
          alignment: TimelineAlign.start,
          endChild: timelineBox(color, hist),
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
        endChild: timelineBox(color, hist),
        beforeLineStyle: const LineStyle(
          thickness: 3,
        ),
        indicatorStyle: IndicatorStyle(
          width: 30,
          height: 30,
          indicatorXY: 0.30,
          indicator: indicatorNew(20, hist.key), //30
          padding: EdgeInsets.only(right: 10),
          // color: index % 2 == 0 ? redbeam : purple,
        ),
      ),
    );
  }

  Widget timelineBox(color, HistoryVac hist) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showGeneralDialog(
              // barrierDismissible: true, //กดบริเวณอื่นให้ออก
              context: context,
              pageBuilder: (context, _, __) {
                return ModalHistory(
                  colorbuttom: white,
                  colormodal: grayBackGroundColor,
                  histList: hist,
                );
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
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: grayBackGroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    txtSmallHeader(hist.key, greyDark),
                    Text(
                      hist.day,
                      style: TextStyle(color: redBurgandy),
                    )
                  ],
                ),
                Divider(
                  color: Colors.black,
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
            // color: yellowPastel,
            color: key != "วัคซีนเสริม" ? redBurgandy : orangeButtonColor2,
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
        itemCount: history.length,
        itemBuilder: (context, index) {
          final history0 = history;
          Color color = bluebeam01;
          String id = history0[index].id;
          return Container(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.2,
              child: SizedBox(
                child: checkIndex(color, index, history[index]),
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
                      history.removeAt(index);
                      FirebaseFirestore.instance
                          .collection("/baby_profile/$userID/vaccine_record")
                          .where("id", isEqualTo: id)
                          .get()
                          .then((snapshot) {
                        BabyInfo.histID.removeAt(index);
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
                  if (BabyInfo.vacHist != null) {
                    BabyInfo.vacHist.clear();
                  }
                  // Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Vaccine()));
                },
              ),
              Text(
                'ประวัติการรับวัคซีน',
                style: TextStyle(fontSize: 20),
              ),
              ImageProfile(
                size: 5,
                color: white,
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
      child: Text(
        'ไม่พบประวัติ',
        style: TextStyle(color: greyDark.withOpacity(0.3), fontSize: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: white,
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
            ),
            child: SafeArea(
              child: headbar(),
            ),
          ),
         BabyInfo.vacHist != null ? Flexible(child: timeLineDev()) : noData(),
        ],
      ),
    );
  }
}
