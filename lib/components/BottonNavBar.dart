import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:BabyBeamApp/myStyle.dart';

import '../signIn.dart';

class BottonNavBar extends StatelessWidget {
  final String titleBottomNavBar;
  final BuildContext context;
  const BottonNavBar({
    Key key,
    this.context,
    this.titleBottomNavBar,
  }) : super(key: key);

  Widget okButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
          processSignOut();
        },
        child: Text('OK'));
  }

  Future<void> processSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => SignIn());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  Widget cancleButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print(size.w)
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 70,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            // color: greenDark,
            width: size.width * 0.29,
            child: BottomNavItem(
              title: 'แจ้งเตือน',
              icon: Icons.text_snippet_outlined,
              isActive: titleBottomNavBar == 'News' ? true : false,
            ),
          ),
          // BottomNavItem(
          //   title: 'แผนที่',
          //   icon: Icons.map_outlined,
          //   isActive: titleBottomNavBar == 'Map' ? true : false,
          // ),
          Container(
            // color: greenDark,
            width: size.width * 0.29,
            child: BottomNavItem(
              title: 'หน้าหลัก',
              icon: Icons.home_outlined,
              isActive: titleBottomNavBar == 'Home' ? true : false,
            ),
          ),
          Container(
            // color: greenDark,
            width: size.width * 0.29,
            child: BottomNavItem(
              title: 'เมนู',
              icon: Icons.dehaze_outlined,
              isActive: titleBottomNavBar == 'Menu' ? true : false,
              press: () {
                // SignOutAleart();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function press;
  final bool isActive;
  const BottomNavItem({
    Key key,
    this.icon,
    this.title,
    this.press,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            icon,
            color: isActive ? greenButtonColor : grayBottomColor,
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Medium',
              color: isActive ? greenButtonColor : grayBottomColor,
            ),
          )
        ],
      ),
    );
  }
}
