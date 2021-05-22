import 'dart:math';
import 'package:BabyBeamApp/addAbnormal.dart';
import 'package:BabyBeamApp/components/imageProfile.dart';
import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/model/graphSympHist.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:BabyBeamApp/symptom.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/babyInfo.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class Abnormal extends StatefulWidget {
  @override
  AbnormalState createState() => AbnormalState();
}

class AbnormalState extends State<Abnormal> {
  List<charts.Series> seriesList;
  List<dynamic> list;
  static List<GraphSympHist> hist = new List();

  void initState() {
    super.initState();
    print(BabyInfo.userID);

    // BabyInfo.graphSympHist.clear();
    readData();
    setState(() {
      hist = BabyInfo.graphSympHist;
    });
  }

  static List sympData;

  Future readData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('/baby_profile/${BabyInfo.userID}/graph')
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) {
      // String symp = data.reference.id;
      // int numb = data.get('num');
      Map<String, dynamic> map = data.data();
      GraphSympHist model = GraphSympHist.fromMap(map);
      print(model);
      setState(() {
        BabyInfo.graphSympHist.add(model);
      });
      print('end : ${BabyInfo.graphSympHist}');
      if (BabyInfo.graphSympHist.length == documents.length) {
        // seriesList = _createData();
        setState(() {
          seriesList = _createData();
        });
      }
    });
  }

  Future<Null> delay(int milliseconds) {
    return new Future.delayed(new Duration(milliseconds: milliseconds));
  }

  static List<charts.Series<GraphSympHist, String>> _createData() {
    return [
      charts.Series<GraphSympHist, String>(
          id: 'sym',
          data: hist,
          domainFn: (GraphSympHist sym, _) => sym.symp,
          measureFn: (GraphSympHist sym, _) => sym.number,
          fillColorFn: (GraphSympHist sym, _) {
            if (sym.symp == "ท้องเสีย") {
              return charts.ColorUtil.fromDartColor(purple);
            } else if (sym.symp == "ปวดศีรษะ") {
              return charts.ColorUtil.fromDartColor(yelloMastard);
            } else if (sym.symp == "ปวดหู") {
              return charts.ColorUtil.fromDartColor(redBurgandy);
            } else if (sym.symp == "มีเสมหะ") {
              return charts.ColorUtil.fromDartColor(greenPastel);
            } else if (sym.symp == "มีไข้") {
              return charts.ColorUtil.fromDartColor(nav);
            } else if (sym.symp == "เจ็บคอ") {
              return charts.ColorUtil.fromDartColor(orangeBackGroundColor2);
            } else if (sym.symp == "เบื่ออาหาร") {
              return charts.ColorUtil.fromDartColor(bluePastel);
            } else if (sym.symp == "เลือดกำเดาไหล") {
              return charts.ColorUtil.fromDartColor(redbeam);
            } else if (sym.symp == "ไอ") {
              //  return charts.MaterialPalette.baby.shadeDefault;
              return charts.ColorUtil.fromDartColor(greenbeam);
            } else
              return charts.MaterialPalette.blue.shadeDefault;

            //           (sym.number == 2)
            //               ? charts.MaterialPalette.red.shadeDefault
            //               : charts.MaterialPalette.blue.shadeDefault;

            // static Palette get blue => const MaterialBlue();
            // static Palette get red => const MaterialRed();
            // static Palette get yellow => const MaterialYellow();
            // static Palette get green => const MaterialGreen();
            // static Palette get purple => const MaterialPurple();
            // static Palette get cyan => const MaterialCyan();
            // static Palette get deepOrange => const MaterialDeepOrange();
            // static Palette get lime => const MaterialLime();
            // static Palette get indigo => const MaterialIndigo();
            // static Palette get pink => const MaterialPink();
            // static Palette get teal => const MaterialTeal();
            // static MaterialGray get gray => const MaterialGray();
          }),
    ];
  }

  barChart() {
    print('Chart : $seriesList');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: size.height * 0.5,
      child: charts.BarChart(
        seriesList,
        animate: true,
        vertical: false,
        defaultRenderer: new charts.BarRendererConfig(
            cornerStrategy: const charts.ConstCornerStrategy(30)),
      ),
    );
  }

  Widget detailbutton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        height: 50.0,
        minWidth: (size.width * 0.8),
        color: greenbeam,
        // .withOpacity(0.3)
        // textColor: greyDark.withOpacity(0.5),
        textColor: white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10,
            ),
            Text('เพิ่มข้อมูล'),
            Container(
              padding: EdgeInsets.zero,
              width: 30,
              height: 30,
              decoration: BoxDecoration(shape: BoxShape.circle, color: white),
              child: Icon(Icons.add_rounded,color: greenbeam,),
              
            ),
          ],
        ),
        onPressed: () => {
          showGeneralDialog(
            // barrierDismissible: true, //กดบริเวณอื่นให้ออก
            context: context,
            pageBuilder: (context, _, __) {
              return AddAbnormal(
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
          )
        },
        splashColor: bage,
      ),
    );
  }

  Widget mentalbutton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        height: 50.0,
        minWidth: (size.width * 0.8),
        color: greyBackground,
        // textColor: greyDark.withOpacity(0.5),
        textColor: white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              'ประวัติทางการแพทย์',
              style: TextStyle(color: greenbeam),
            ),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Symptom()))
        },
        splashColor: bage,
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
                          MaterialPageRoute(builder: (context) => Home()));
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
                        'อาการผิดปกติ',
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
        // Positioned(
        //   top: 10,
        //   right: 0,
        //   child: add(),
        // ),
      ],
    );
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    seriesList = _createData();
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
                  // height: 500,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: 0,
                child: Column(
                  children: [
                    header(),
                    hist.length==0?
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 200),
                    child: Text('ไม่พบข้อมูลอาการผิดปกติ',style: TextStyle(color: greyDark),),)
                    :
                  Flexible(
                      child: barChart(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    detailbutton(),
                    SizedBox(
                      height: 20,
                    ),
                    mentalbutton()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
  }
}

class Sym {
  final String sym;
  final int numsym;
  Sym(
    this.numsym,
    this.sym,
  );
  //  this.day,
}
