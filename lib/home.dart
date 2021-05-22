import 'package:BabyBeamApp/abnormal.dart';
import 'package:BabyBeamApp/baby_profile.dart';
import 'package:BabyBeamApp/components/sideBar.dart';
import 'package:BabyBeamApp/development.dart';
import 'package:BabyBeamApp/health.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/historyDev.dart';
import 'package:BabyBeamApp/model/historyVac.dart';
import 'package:BabyBeamApp/model/user.dart';
import 'package:BabyBeamApp/vaccine.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'components/category_button.dart';
import 'components/imageProfile.dart';
import 'model/graphSympHist.dart';
import 'model/modelVac02.dart';
import 'myStyle.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final databaseReference = FirebaseFirestore.instance;

  String login = '...';
  String firstname = '...';
  String lastname = '...';
  String nickname = '...';
  String sex = '...';
  String birthDay = '...';
  int ageY, ageM, ageD;
  String userID;
  String rangeMe;
  var age;
// String vacShow;
  // Method

  @override
  void initState() {
    BabyInfo().readData();
    super.initState();
    setState(() {
      Account().getUserID();
      userID = Account.userID;
    });
    readData();
    // getVacHistory();
  }

  Future getVacHistory() async {
    BabyInfo.vacHist.clear();
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
            HistoryVac model = HistoryVac.fromMap(map);
            setState(() {
              BabyInfo.vacHist.add(model);
            });
          });
        }
        // print("HisList in Home : ${BabyInfo.vacHist}");
      } else {
        print('No History');
      }
    });
  }

  Future readDataGraph() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('/baby_profile/${BabyInfo.userID}/graph')
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) {
      // String symp = data.reference.id;
      // int numb = data.get('num');
      Map<String, dynamic> map = data.data();
      GraphSympHist model = GraphSympHist.fromMap(map);
      setState(() {
        BabyInfo.graphSympHist.add(model);
      });
    });
  }

  Future getDevHistory() async {
    BabyInfo.devHist.clear();
    FirebaseFirestore.instance
        .collection('/baby_profile/$userID/development_record')
        // .orderBy("time", descending: true)
        .snapshots()
        .listen((event) {
      List<QueryDocumentSnapshot> snapshot2 = event.docs;
      if (snapshot2.isNotEmpty) {
        for (var snap in snapshot2) {
          setState(() {
            // importent
            Map<String, dynamic> map = snap.data();
            HistoryDev model = HistoryDev.fromMap(map);
            setState(() {
              BabyInfo.devHist.add(model);
            });
          });
        }
      } else {
        print('No Dev History');
      }
    });
  }

  Future<void> readData() async {
    DocumentSnapshot info = await FirebaseFirestore.instance
        .collection('baby_profile')
        .doc(userID)
        .get();
    setState(() {
      ageY = info.get('ageY');
      ageM = info.get('ageM');
      ageD = info.get('ageD');
      firstname = info.get('first_name');
      lastname = info.get('last_name');
      nickname = info.get('nickname');
      sex = info.get('sex');
      birthDay = info.get('birthDate');
      age = double.parse("$ageY.$ageM");
    });
  }

  String getAge() {
    String year = "";
    String month = "";
    String day = "";
    if (ageY != 0 || ageM != 0 || ageD != 0) {
      if (ageY != 0) {
        year = "${ageY} ปี";
      }
      if (ageM != 0) {
        month = " ${ageM} เดือน";
      }
      if (ageD != 0) {
        day = " ${ageD} วัน";
      }
      return "$year$month$day";
    } else
      return "แรกเกิด";
  }

  findRangeDev() async {
    age = double.parse("${ageY}.${ageM}");
    print('Age $age');

    FirebaseFirestore.instance
        .collection('/development')
        .snapshots()
        .listen((event) {
      List<QueryDocumentSnapshot> snapshot = event.docs;
      if (snapshot.isNotEmpty) {
        for (var snap in snapshot) {
          Map<String, dynamic> map = snap.data();
          ModelVac02 model = ModelVac02.fromMap(map);
          var parts = model.s.split('.');
          String yStart = parts[0];
          String mStart = parts[1];
          var parte = model.e.split('.');
          String yEnd = parte[0];
          String mEnd = parte[1];
          print('xddd : ${model.s} - ${model.e}');
          if ((ageY == 0 && ageM == 10) ||
              (ageY == 0 && ageM == 11) ||
              (ageY == 1 && ageM == 0)) {
            print('Found Age Range 0.10-1.0');
            BabyInfo.devRange = "0.10-1.0";
            setState(() {});
          }
          if (mEnd.length == 2 || mStart.length == 2 || ageM >= 9) {
            if (ageY.clamp(double.parse(yStart), double.parse(yEnd)) == ageY &&
                double.parse(mStart) <= ageM) {
              rangeMe = "${model.s}-${model.e}";
              print('Found Age Range len2');
              BabyInfo.devRange = rangeMe;
              setState(() {});
            }
          } else if (age.clamp(double.parse(model.s), double.parse(model.e)) ==
              age) {
            rangeMe = "${model.s}-${model.e}";
            print('Found Age Range');
            BabyInfo.devRange = rangeMe;
            setState(() {});
          }
        }
      }
    });
  }

  findRangeVac() async {
    age = double.parse("${ageY}.${ageM}");
    print('Age $age');

    FirebaseFirestore.instance.collection('/vac02').snapshots().listen((event) {
      List<QueryDocumentSnapshot> snapshot = event.docs;
      if (snapshot.isNotEmpty) {
        for (var snap in snapshot) {
          Map<String, dynamic> map = snap.data();
          ModelVac02 model = ModelVac02.fromMap(map);
          if (age.clamp(double.parse(model.s), double.parse(model.e)) == age) {
            rangeMe = "${model.s}-${model.e}";
            print('Found Age Range');
            BabyInfo.ageRange = rangeMe;
            setState(() {});
          }
        }
        print('Year Range : $rangeMe');
      }
    });
  }

  Widget headerbar(context) {
    return Container(
      // margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          // modalFormTop(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              groupImage(120.0),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ชื่อ',
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                  Text(
                    'วันเกิด',
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                  Text(
                    'เพศ',
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                  // Text(
                  //   'หมู่เลือด',
                  //   style: TextStyle(color: white, fontSize: 18),
                  // ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${firstname} ${lastname}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 4,
                  ),
                  Text(birthDay, style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 4,
                  ),
                  Text(sex, style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 190,
                  child: Text(
                    'ครอบครัว $login',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: white, fontSize: 16),
                  )),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                  flex: 7,
                  child: Icon(
                    Icons.settings,
                    color: white,
                  ))
            ],
          ),
        ],
      ),
      decoration: new BoxDecoration(
        color: greenbeam,
        borderRadius: new BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: greenbeam.withOpacity(0.4),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
    );
  }

  Row groupImage(size) => Row(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: white),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // border: Border.all(),color: white,
                    image: DecorationImage(
                      image: AssetImage('images/user128.png'),
                      // image: FileImage(imagebaby),
                      // fit: BoxFit.fill
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );

  Widget headProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageProfile(
          size: 50.0,
          color: white,
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            txtSmallHeader('${firstname} ${lastname}', greyDark),
            SizedBox(
              height: 5,
            ),
            Text(
              getAge(),
              style: TextStyle(color: greyDark, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget headBar() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: blue_Grey.withOpacity(0.7)),
            child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: white,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                }),
          ),
          txtSmallHeader(nickname, greyLight),
          Container(
            margin: EdgeInsets.all(10),
            width: 50,
            height: 50,
            // color: greenbeam,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: blue_Grey.withOpacity(0.7)),
            child: IconButton(
                icon: Icon(
                  Icons.edit_rounded,
                  color: white,
                ),
                onPressed: () {
                  readDataGraph();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BabyProfile()));
                }),
          ),
        ],
      ),
    );
  }

  Widget section(String title) {
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.caption,
        ));
  }

  // Widget carousel() {
  //   return Container(
  //     child: CarouselSlider(
  //       options: CarouselOptions(
  //         height: size.height * 0.10,
  //         autoPlay: true,
  //         autoPlayInterval: Duration(seconds: 5),
  //         enlargeCenterPage: true,
  //         viewportFraction: 1.0,
  //         reverse: true,
  //         scrollDirection: Axis.vertical,
  //       ),
  //       items: [1, 2, 3].map((i) {
  //         return Builder(
  //           builder: (BuildContext context) {
  //             return Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 margin: EdgeInsets.symmetric(horizontal: 5.0),
  //                 decoration: BoxDecoration(
  //                     color: white,
  //                     borderRadius: BorderRadius.circular(5)),
  //                 child: Center(
  //                   child: Text(
  //                     'text $i',
  //                     style: TextStyle(fontSize: 16.0),
  //                   ),
  //                 ));
  //           },
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
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
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 150, left: 25, right: 25, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: size.width * 0.1),
                  SizedBox(height: size.width * 0.05),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CategoryButton(
                          title: 'สุขภาพ',
                          svgSrc: 'images/health.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Health();
                                },
                              ),
                            );
                          },
                        ),
                        CategoryButton(
                          title: 'พัฒนาการ',
                          svgSrc: 'images/development.svg',
                          press: () {
                            findRangeDev();
                            getDevHistory();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Development()));
                          },
                        ),
                        CategoryButton(
                          title: 'อาการป่วย',
                          svgSrc: 'images/medical.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Abnormal();
                                },
                              ),
                            );
                          },
                        ),
                        CategoryButton(
                          title: 'วัคซีน',
                          svgSrc: 'images/vaccine.svg',
                          press: () {
                            // BabyInfo.vacHist.clear();
                            findRangeVac();
                            // getVacHistory();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Vaccine();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // signOut(),
          ),
        ],
      ),
      drawer: SideBar(),
    );
  }
}
