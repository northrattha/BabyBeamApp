import 'package:BabyBeamApp/components/modalAddVaccine.dart';
import 'package:BabyBeamApp/components/modaladdOtherVacc.dart';
import 'package:BabyBeamApp/components/sideBar.dart';
import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/historyVac.dart';
import 'package:BabyBeamApp/model/vaccineList.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:BabyBeamApp/components/imageProfile.dart';
import 'package:BabyBeamApp/vaccineHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/user.dart';

class Vaccine extends StatefulWidget {
  @override
  _VaccineState createState() => _VaccineState();
}

class _VaccineState extends State<Vaccine> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final databaseReference = FirebaseFirestore.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<VaccineList> vacList = new List();
  String userID;
  String birthDate = '...';
  int ageD;
  DateTime date;
  List<String> vaccineForAge;
  String key = '...';
  String tests = '...';
  List<HistoryVac> hisvac = new List();
  // Color primary = redBurgandy;
  Color primaryButton = grayShadowColor;
  Color primary = grayBackGroundColor;



  @override
  void initState() {
    super.initState();
    readData();
    getHistory();
       
  }

  Future<void> getHistory() async {
    String userID = Account.userID;
    await FirebaseFirestore.instance
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
            HistoryVac model = HistoryVac.fromMap(map);
            hisvac.add(model);
            BabyInfo.histID.add(snap["id"]);
          });
        }
        BabyInfo.vacHist = hisvac;
        // print("Have BABY HIST : ${BabyInfo.vacHist.toSet()}");
      } else {
        print('No History');
      }
    });
  }

  Future<void> readData() async {
    print('Mark historyID : ${BabyInfo.histID.toSet()}');
    await FirebaseFirestore.instance
        .collection('/vac02/${BabyInfo.ageRange}/vac')
        .snapshots()
        .listen((event) {
       List<QueryDocumentSnapshot> snapshot2 = event.docs;
      if (snapshot2.isNotEmpty) {
        for (var snap in snapshot2) {
          Map<String, dynamic> map = snap.data();
          map["id"] = snap.id;
          VaccineList model = VaccineList.fromMap(map);
          // print(model);
          setState(() {
            // importent
            vacList.add(model);
          });
        }
      } else {
        print('No Vaccine');
                readData();

      }
    });
  }

  Widget buildList() {
      HistoryVac filtered;
    return ListView.builder(
      itemCount: vacList.length,
      itemBuilder: (context, index) {
        String id = vacList[index].id;
        // find histoy in ths vaccine
        // print("thhhhh : ${BabyInfo.vacHist}");
        if (BabyInfo.vacHist != null) {
          var filter =
              BabyInfo.vacHist.where((content) => content.id == id).toList();
          filtered = filter.asMap()[0];
        }
        // print('His This INDEX = ${filtered}');
        return Container(
          padding: EdgeInsets.only(top: 15, left: 50, right: 50),
          child: buttonVaccine(index, filtered),
        );
      },
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
            size: 100.0,
            color: orangeButtonColor2,
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
                  height: 5,
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

  Widget vaccineHistory() {
    return RaisedButton(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      color: orangeButtonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      child: Text(
        'ประวัติการรัซีน',
        style: TextStyle(
          color: Colors.grey[800],
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VaccinHistory()),
        );
      },
    );
  }

  Widget contentVaccine() {
    return Container(
// color: bluePastels,
      padding: EdgeInsets.only(top: 110),
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
          SizedBox(
            height: 0,
          ),
          addOtherVaccine(),
        ],
      ),
    );
  }

  Widget buttonVaccine(int index, HistoryVac hist) {
    return RaisedButton(
      padding: EdgeInsets.all(20),
      color: BabyInfo.histID.contains(vacList[index].id) ? bage : white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 43,
            alignment: Alignment.center,
            child: Text(vacList[index].key),
          ),
          SizedBox(
            width: 19,
          ),
          Container(
            width: 190,
            child: Text(vacList[index].name),
          ),
        ],
      ),
      onPressed: () {
        showGeneralDialog(
          // barrierDismissible: true, //กดบริเวณอื่นให้ออก
          context: context,
          pageBuilder: (context, _, __) {
            return ModalVaccine(
                colorbuttom: white,
                colormodal: primary,
                vacList: vacList[index],
                histList: hist);
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
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
    );
  }

  Widget addOtherVaccine() {
    return Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.only(bottom: 45),
        child: RaisedButton(
          padding: EdgeInsets.zero,
          shape: CircleBorder(),
          color: orangeButtonColor2,
          child: Icon(
            Icons.add_rounded,
            color: white,
            size: 40,
          ),
          onPressed: () {
            showGeneralDialog(
                // barrierDismissible: true, //กดบริเวณอื่นให้ออก
                context: context,
                pageBuilder: (context, _, __) {
                  return ModaladdOtherVacc(
                    colormodal: primary,
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
                });
          },
        ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SizedBox(
        height: 825,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              color: grayBackGroundColor,
              padding: EdgeInsets.only(top: 80),
              child: Mystyle().textButtonHeadbar('วัคซีน'),
            ),
            Positioned.fill(
              top: 200,
              child: contentVaccine(),
            ),
            headInfo(),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              alignment: Alignment.bottomRight,
            ),
            Row(
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
                        color: orangeButtonColor,
                      ),
                      onPressed: () {
                        // Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
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
                        color: orangeButtonColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VaccinHistory()));
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      drawer: SideBar(),
    );
  }
}
