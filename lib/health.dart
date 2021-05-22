import 'package:BabyBeamApp/components/button_back_pages.dart';
import 'package:BabyBeamApp/components/category_button.dart';
import 'package:BabyBeamApp/components/photo.dart';
import 'package:BabyBeamApp/healthBMI.dart';
import 'package:BabyBeamApp/healthHeadCircumference.dart';
import 'package:BabyBeamApp/healthHeight.dart';
import 'package:BabyBeamApp/healthWeight.dart';
import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/healthStandard.dart';
import 'package:BabyBeamApp/model/historyHealth.dart';
import 'package:flutter/material.dart';

class Health extends StatefulWidget {
  @override
  _HealthState createState() => _HealthState();
}

class _HealthState extends State<Health> {
  @override
  // void initState() {
  //   BabyInfo().readData();

  //   super.initState();
  //   setState(() {
  //     UserClass().getUser();
  //     userID = UserClass.userID;
  //   });
  // }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Read Data Health Baby and Standard
    HistoryHealth().readHistory('weight', BabyInfo.ageY);
    HealthStandard().readStandard('Weight', BabyInfo.ageY, BabyInfo.sex);
    HealthStandard().readMedianListStandard('Weight', BabyInfo.sex);

    HistoryHealth().readHistory('height', BabyInfo.ageY);
    HealthStandard().readStandard('Height', BabyInfo.ageY, BabyInfo.sex);
    HealthStandard().readMedianListStandard('Height', BabyInfo.sex);

    HistoryHealth().readHistory('headCircumference', BabyInfo.ageY);
    HealthStandard()
        .readStandard('Head_Circumference', BabyInfo.ageY, BabyInfo.sex);
    HealthStandard().readMedianListStandard('Head_Circumference', BabyInfo.sex);

    HistoryHealth().readHistory('bmi', BabyInfo.ageY);
    HealthStandard().readStandard('BMI', BabyInfo.ageY, BabyInfo.sex);
    HealthStandard().readMedianListStandard('BMI', BabyInfo.sex);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ButtonBackPages(
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Home();
                          },
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      'สุขภาพ',
                      style: TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Photo(),
                ],
              ),
              SizedBox(height: size.width * 0.15),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: .85,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: <Widget>[
                    CategoryButton(
                      title: 'น้ำหนัก',
                      svgSrc: 'images/weight.svg',
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HealthWeight();
                            },
                          ),
                        );
                      },
                    ),
                    CategoryButton(
                      title: 'ส่วนสูง',
                      svgSrc: 'images/height.svg',
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HealthHeight();
                            },
                          ),
                        );
                      },
                    ),
                    CategoryButton(
                      title: 'รอบศีรษะ',
                      svgSrc: 'images/headcircumference.svg',
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HealthHeadCircumference();
                            },
                          ),
                        );
                      },
                    ),
                    CategoryButton(
                      title: 'ดัชนีมวลกาย',
                      svgSrc: 'images/bmi.svg',
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HealthBMI();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
