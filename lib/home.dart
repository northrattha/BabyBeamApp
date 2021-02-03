import 'package:BabyBeamApp/baby_profile.dart';
import 'package:BabyBeamApp/components/imageProfile.dart';
import 'package:BabyBeamApp/health.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:BabyBeamApp/signIn.dart';
import 'package:BabyBeamApp/vaccine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/BottonNavBar.dart';
import 'components/category_button.dart';
import 'components/small_rounded_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Explict
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final databaseReference = FirebaseFirestore.instance;

  String login = '...';
  String firstname = '...';
  String lastname = '...';
  String nickname = '...';
  String sex = '...';
  String birthDay = '...';
  // var imagebaby;
  String userID;

  // Method

  @override
  void initState() {
    super.initState();
    readData();
    findDisplayName();
  }

  void updateAge(DateTime date) {
    setState(() {});
  }

  Future<void> getUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    userID = user.uid;
  }

  Future<void> readData() async {
    getUser();
    // print('moiii22i $userID');
    DocumentSnapshot info = await FirebaseFirestore.instance
        .collection('baby_profile')
        .doc(userID)
        .get();
    print(info.get('first_name'));
    setState(() {
      firstname = info.get('first_name');
      lastname = info.get('last_name');
      nickname = info.get('nickname');
      sex = info.get('sex');
      birthDay = info.get('birthDate');
      // imagebaby = info.get('imagebaby');
    });
  }

  Future<void> findDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    setState(() {
      login = user.displayName;
    });
  }

  Future<void> readAllData() async {
    // ดึงข้อมูลจาก firestore
    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
        firebaseFirestore.collection('baby_profile'); // in DB
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.docs;
      for (var snapshot in snapshots) {
        print('object = $snapshot');
        print('Name = ${snapshot.get('first_name')}'); // in DB
      }
    });
  }

  Future<void> ShowName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    setState(() {
      // name = user.;
    });
  }

  // Widget signOut() {
  //   return IconButton(
  //       icon: Icon(Icons.exit_to_app),
  //       tooltip: 'Sign Out',
  //       onPressed: () {
  //         SignOutAleart();
  //       });
  // }

  // Widget SignOutAleart() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('ออกจากระบบ ?'),
  //           content: Text('คุณต้องการออกจากระบบใช่ไหม'),
  //           actions: <Widget>[cancleButton(), okButton()],
  //         );
  //       });
  // }

  // Widget okButton() {
  //   return FlatButton(
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //         processSignOut();
  //       },
  //       child: Text('OK'));
  // }

  // Future<void> processSignOut() async {
  //   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //   await firebaseAuth.signOut().then((response) {
  //     MaterialPageRoute materialPageRoute =
  //         MaterialPageRoute(builder: (BuildContext context) => SignIn());
  //     Navigator.of(context).pushAndRemoveUntil(
  //         materialPageRoute, (Route<dynamic> route) => false);
  //   });
  // }

  // Widget cancleButton() {
  //   return FlatButton(
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //       child: Text('Cancel'));
  // }

  Widget modalFormTop(context) {
    return OutlineButton(
        // color: greenbeam,
        child: Text(
          nickname,
          style: TextStyle(color: white, fontSize: 20),
        ),
        onPressed: () {
          return showGeneralDialog(
            context: context,
            barrierDismissible: true, //กดบริเวณอื่นให้ออก
            transitionDuration: Duration(milliseconds: 400), //ความเร็ว
            barrierLabel: MaterialLocalizations.of(context).dialogLabel,
            // barrierColor: Colors.black.withOpacity(0.5),
            pageBuilder: (context, _, __) {
              return Material(
                type: MaterialType.transparency,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(50),
                        height: 450,
                        width: 500,
                        decoration: BoxDecoration(
                          color: greenbeam,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                        ),
                        child: Column(
                          children: [
                            OutlineButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                nickname,
                                style: TextStyle(color: white, fontSize: 20),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                groupImage(90.0),
                                const SizedBox(
                                  width: 20,
                                ),
                                Mystyle().TextButtonModal(nickname),
                              ],
                            ),
                            line(1.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                groupImage(90.0),
                                const SizedBox(
                                  width: 20,
                                ),
                                Mystyle().TextButtonModal('หนูแดง')
                              ],
                            ),
                            line(1.0),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: white,
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Mystyle().TextButtonModal('เพิ่มลูกของคุณ')
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
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

  _showModalBottom(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            // alignment: Alignment.topCenter,
            padding: EdgeInsets.all(500),
            height: 300,
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
          );
        });
  }

  Widget headerbar(context) {
    return Container(
      // margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          modalFormTop(context),
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
                  Text('$firstname $lastname', style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 4,
                  ),
                  Text(birthDay, style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 4,
                  ),
                  Text(sex, style: TextStyle(fontSize: 16)),
                  // Text('A', style: TextStyle(fontSize: 16))
                ],
              ),
              // Icon(Icons.settings)
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: greenBackGroundColor,
      bottomNavigationBar: BottonNavBar(
        titleBottomNavBar: 'Home',
        context: context,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              color: purpleBackGroundColor,
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage('images/cloud.png'),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          nickname,
                          style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 36,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            alignment: Alignment.center,
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('images/user128.png'),
                              )
                                  //           image: DecorationImage(
                                  // image: AssetImage('images/user128.png'),
                                  ),
                              // child: Icon(Icons.person_rounded),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SmallRoundedButton(
                    text: 'ดูข้อมูลส่วนตัว',
                    icon: Icons.navigate_next_rounded,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Baby_profile();
                          },
                        ),
                      );
                    },
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
                          title: 'สุขภาพ',
                          svgSrc: 'images/health.svg',
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return HealthPage();
                                },
                              ),
                            );
                          },
                        ),
                        CategoryButton(
                          title: 'พัฒนาการ',
                          svgSrc: 'images/development.svg',
                          press: () {},
                        ),
                        CategoryButton(
                          title: 'อาการป่วย',
                          svgSrc: 'images/medical.svg',
                          press: () {},
                        ),
                        CategoryButton(
                          title: 'วัคซีน',
                          svgSrc: 'images/vaccine.svg',
                          press: () {
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
                  // signOut(),
                ],
              ),
            ),
          ),
          // signOut(),
        ],
        // SignOut
        // FlatButton(
        //   onPressed: () {
        //     auth.signOut();
        //     Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (context) => SignIn()));
        //   },
        //   child: Text('ออกจากระบบ'),
        // ),
      ),
    );
  }
}
