import 'package:BabyBeamApp/abnormal.dart';
import 'package:BabyBeamApp/components/modalAddSymptom.dart';
import 'package:BabyBeamApp/medicalHistory.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'components/imageProfile.dart';
import 'model/babyInfo.dart';

class Symptom extends StatefulWidget {
  @override
  _SymptomState createState() => _SymptomState();
}

class _SymptomState extends State<Symptom> {
  Color primaryButton = greenDark;
  Size size;
  Color boxColor = white;
  Color contentColor = grayBackGroundColor;
  Color primary = greenbeam;
  List<String> drugList = new List();
  List<String> foodList = new List();
  List<String> diseaseList = new List();

  @override
  void initState() {
    super.initState();
    // print('read');
    readData();
  
  }

  Future<void> readData() async {
    // print('future');
    final QuerySnapshot drugresult = await FirebaseFirestore.instance
        .collection(
            'baby_profile/${BabyInfo.userID}/medical_problems/medical_problems/drug')
        // .orderBy('name')
        .get();

    final List<DocumentSnapshot> documents0 = drugresult.docs;
    documents0.forEach((data) {
      String name = data.get('name');
      setState(() {
        drugList.add(name);
      });
    });

    final QuerySnapshot foodresult = await FirebaseFirestore.instance
        .collection(
            'baby_profile/${BabyInfo.userID}/medical_problems/medical_problems/food')
        .get();

    final List<DocumentSnapshot> documents1 = foodresult.docs;
    documents1.forEach((data) {
      String name = data.get('name');
      // print(name);
      setState(() {
        foodList.add(name);
      });
    });

    final QuerySnapshot diseaseresult = await FirebaseFirestore.instance
        .collection(
            'baby_profile/${BabyInfo.userID}/medical_problems/medical_problems/disease')
        .get();

    final List<DocumentSnapshot> documents2 = diseaseresult.docs;
    documents2.forEach((data) {
      String name = data.get('name');
      // print(name);
      setState(() {
        diseaseList.add(name);
      });
    });
  }

  Widget header() {
    return Container(
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
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Abnormal()));
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
                    'ประวัติทางการแพทย์',
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
        ],
      ),
    );
  }

  Widget medHistbutton() {
    return Container(
      // color: yelloMastard,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        height: 50.0,
        minWidth: (size.width * 0.8),
        color: white,
        textColor: greyDark,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10,
            ),
            Text('ประวัติการรักษา'),
            Icon(Icons.arrow_forward_ios_rounded),
            
          ],
        ),
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Medicalhistory()))
        },
        splashColor: bage,
      ),
    );
  }

  Widget title(String name, String type, List list) {
    // print('title');
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.4,
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            width: 30,
            height: 30,
            child: RaisedButton(
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
                color: primary,
                child: Icon(
                  Icons.add_rounded,
                  color: grayBackGroundColor,
                ),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (context, _, __) {
                      return ModalAddSymptom(
                        hist: list,
                        colormodal: primary,
                        type: type,
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
                }),
          ),
        ],
      ),
    );
  }

  Widget builder(List list, String type) {
    setState(() {});
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(), // importent
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Container(
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.2,
            child: SizedBox(
              child: Container(
                margin: EdgeInsets.only(bottom: 25),
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                alignment: Alignment.topLeft,
                width: size.width * 0.75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: grayBackGroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(list[index]),
                  ],
                ),
              ),
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
                    FirebaseFirestore.instance
                        .collection(
                            "baby_profile/${BabyInfo.userID}/medical_problems/medical_problems/$type")
                        .where("name", isEqualTo: list[index])
                        .get()
                        .then((snapshot) {
                      snapshot.docs.first.reference.delete().then((value) {
                        print("Remove Success :${BabyInfo.userID} ");
                        setState(() {
                          list.removeAt(index);
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
    );
  }

  Widget box(String name, String type, List list) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 40),
            width: size.width * 0.8,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 1000),
              child: Container(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: list.length != 0
                    ? builder(list, type)
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ไม่พบข้อมูล',
                              style: TextStyle(
                                color: greyDark.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          title(name, type, list),
        ],
      ),
    );
  }

  Widget content() {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          medHistbutton(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.only(top:10.0,bottom: 15),
            child: Divider(color: white.withOpacity(0.5),thickness: 4,),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 1000), // **THIS is the important part**
            child: box('การแพ้ยา', 'drug', drugList),
            // child
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 1000), // **THIS is the important part**
            child: box('การแพ้อาหาร', 'food', foodList),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 1000), // **THIS is the important part**
            child: box('โรคประจำตัว', 'disease', diseaseList),
          ),
        ],
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('ddd : ${BabyInfo.userID}');
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: greyBackground,
      body: SafeArea(
        child: SizedBox(
          child: Stack(
            children: [
              Positioned.fill(
                // top: 108,
                top: 91,
                child: Container(
                  decoration: BoxDecoration(
                    color: contentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: content(),
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