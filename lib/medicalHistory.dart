import 'package:BabyBeamApp/components/imageProfile.dart';
import 'package:BabyBeamApp/components/modalMedHistory.dart';
import 'package:BabyBeamApp/model/medHist.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:BabyBeamApp/symptom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'model/babyInfo.dart';

class Medicalhistory extends StatefulWidget {
  @override
  _MedicalhistoryState createState() => _MedicalhistoryState();
}

class _MedicalhistoryState extends State<Medicalhistory> {
  Size size;
  List<MedHist> medHist = new List();

  void initState() {
    super.initState();
    readData();
  }

  Future<void> readData() async {
    final QuerySnapshot histresult = await FirebaseFirestore.instance
        .collection(
            "/baby_profile/${BabyInfo.userID}/medical_problems/medical_history/medical_history")
        .orderBy('time', descending: true)
        .get();

    final List<DocumentSnapshot> documents = histresult.docs;
    documents.forEach((snap) {
      // String name = data.get('name');
      // print(name);
      setState(() {
        Map<String, dynamic> map = snap.data();
        MedHist model = MedHist.fromMap(map);
        medHist.add(model);
      });
    });
  }

  Widget timeLineVaccine() {
    return Container(
      child: ListView.builder(
        itemCount: medHist.length,
        itemBuilder: (context, index) {
          String titleHist = medHist[index].title;
          return Container(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  timeLineBox(medHist[index]),
                ],
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
                      medHist.removeAt(index);
                      FirebaseFirestore.instance
                          .collection(
                              "/baby_profile/${BabyInfo.userID}/medical_problems/medical_history/medical_history")
                          .where("title", isEqualTo: titleHist)
                          .get()
                          .then((snapshot) {
                        snapshot.docs.first.reference.delete().then((value) {
                          print("Remove Success");
                          setState(() {});
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

  Widget timeLineBox(MedHist hist) {
    return new Container(
      width: 320,
      margin: EdgeInsets.only(bottom: 25),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25)),
        color: grayBackGroundColor,
        boxShadow: [
          BoxShadow(
            color: greenbeam,
            spreadRadius: 0.5,
            blurRadius: 0,
            offset: Offset(-5, 0), // changes position of shadow
          ),
          BoxShadow(color: Colors.white, offset: Offset(0, -16)),
          BoxShadow(color: Colors.white, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              txtSmallHeader(hist.title, greyDark),
              Text(
                hist.day,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          SizedBox(
            height: 10,
          ),
          hist.detail==""?Text('  -'):Text(hist.detail),
        ],
      ),
    );
  }

  Widget header() {
    return Stack(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: greenDark,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Symptom()));
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  ImageProfile(
                    size: 40,
                    color: white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ประวัติการรักษา',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("${BabyInfo.firstname}   ${BabyInfo.lastname}"),
                    ],
                  )
                ],
              ),
              // add(),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 0,
          child: add(),
        ),
      ],
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

  Widget add() {
    return MaterialButton(
        shape: CircleBorder(),
        color: greenbeam,
        child: Icon(
          Icons.add_rounded,
          color: white,
          size: 40,
        ),
        onPressed: () {
          showGeneralDialog(
            context: context,
            pageBuilder: (context, _, __) {
              return ModalMedHistory(
                colorbuttom: white,
                colormodal: grayBackGroundColor,
              );
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
        });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print('Build : $medHist');
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: greyBackground,
      body: SafeArea(
        child: SizedBox(
          child: Stack(
            children: [
              Positioned.fill(
                top: 91,
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Flexible(
                          child: medHist.length != 0
                              ? timeLineVaccine()
                              : noData()),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                top: 0,
                child: header(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
