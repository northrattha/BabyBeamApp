import 'package:BabyBeamApp/components/BackButtonBeam.dart';
import 'package:BabyBeamApp/components/imageProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:timeline_tile/timeline_tile.dart';
// import 'package:timelines/timelines.dart';

import 'components/BottonNavBar.dart';
import 'myStyle.dart';

class VaccinHistory extends StatefulWidget {
  @override
  _VaccinHistoryState createState() => _VaccinHistoryState();
}

class _VaccinHistoryState extends State<VaccinHistory> {
  String userID;
  int ageY, ageM, ageD;
  String nickname = '...';
  String firstname = '...';
  String lastname = '...';

  @override
  void initState() {
    super.initState();
    readData();
  }

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
      firstname = info.get('first_name');
      lastname = info.get('last_name');
    });
  }

  Future<void> getUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    ;
    userID = user.uid;
  }

  Widget headBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BackButtonBeam(
          background: blue_Grey,
          color: Colors.black,
        ),
        SafeArea(
          child: txtSmallHeader('Vaccine History', greyLight),
        ),
        SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            width: 50,
            height: 50,
            // color: greenbeam,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: blue_Grey.withOpacity(0.7)),
            child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
      ],
    );
  }

  Widget headProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageProfile(
          size: 50.0,
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            txtSmallHeader('$firstname $lastname', greyDark),
            // Text(
            //   'อายุ : $ageY ปี $ageM เดือน $ageD วัน',
            //   style: TextStyle(color: greyDark, fontWeight: FontWeight.w600),
            // ),
            (ageY == 0 && ageM == 0 && ageD == 0)
                    ? Text('แรกเกิด',style: TextStyle(color: greyDark, fontWeight: FontWeight.w600),)
                    : Text('${ageY} ปี ${ageM} เดือน',style: TextStyle(color: greyDark, fontWeight: FontWeight.w600),),
          ],
        ),
      ],
    );
  }

  double dotsize = 30;
  Widget buildList() {
    return ListView.builder(
      // itemCount: items.length,
      itemCount: 10,
      itemBuilder: (context, index) {
        Color color = bluebeam01;
        if (index % 2 == 0) {
          dotsize = 30;
          // color = redbeam.withOpacity(0.5);
        }
        if (index % 3 == 0) {
          dotsize = 20;
          // color = yellowPastel.withOpacity(0.4);
        }
        if (index == 0) {
          return SizedBox(
            child: TimelineTile(
              alignment: TimelineAlign.start,
              endChild: timelineBox(color),
              isFirst: true,
              beforeLineStyle: const LineStyle(thickness: 3),
              indicatorStyle: IndicatorStyle(
                  width: 30,
                  height: 30,
                  indicator: indicatorNew(30),
                  indicatorXY: 0.30,
                  padding: EdgeInsets.only(right: 10),
                  color: purpleButtonColor),
            ),
          );
        }
        if (index == 9) {
          return SizedBox(
            child: TimelineTile(
              alignment: TimelineAlign.start,
              // endChild: timelineBox(),
              endChild: timelineBox(color),
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
            endChild: timelineBox(color),
            // child: timelineBox(),
            beforeLineStyle: const LineStyle(
              thickness: 3,
            ),
            indicatorStyle: IndicatorStyle(
              width: 30,
              height: 30,
              indicatorXY: 0.30,
              indicator: indicatorNew(dotsize),
              padding: EdgeInsets.only(right: 10),
              // color: index % 2 == 0 ? redbeam : purple,
            ),
          ),
        );
      },
    );
  }

  Widget indicatorNew(double dotsize) {
    // return Container(width: 60,height: 100,color: Colors.black,);
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
            color: yellowPastel,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget timeLineVaccine() {
    return Container(
      width: 360,
      padding: EdgeInsets.only(left: 30),
      child: Flexible(child: buildList()),
    );
  }

  Widget timelineBox(color) {
    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            // color: bluebeam01
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                topRight: Radius.circular(25)),
            color: color,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  txtSmallHeader('HB1', greyDark),
                  Text(
                    '20/02/0202',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
              Text('วัตซีนป้องกันโรคคคค')
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body: Column(children: [
      //   Flexible(child: Container(child: timeLineVaccine(),))
      // ],),
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
              color: greyBackground,
            ),
            child: Column(
              children: [
                headBar(),
                headProfile(),
                SizedBox(
                  height: 10,
                )
                // timeLine(),
              ],
            ),
          ),
          Flexible(
            child: timeLineVaccine(),
          )
          // Flexible(
          //   child: TimelineTile(
          //     axis: TimelineAxis.horizontal,
          //     alignment: TimelineAlign.start,
          //     lineXY: 0.3,
          //     endChild: Container(
          //       constraints: const BoxConstraints(
          //         minWidth: 120,
          //       ),
          //       color: Colors.lightGreenAccent,
          //     ),
          //     startChild: Container(
          //       color: Colors.amberAccent,
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: BottonNavBar(
        titleBottomNavBar: 'Home',
      ),
    );
  }
}
