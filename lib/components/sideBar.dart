import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/user.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../babyProfileOld.dart';
import '../signIn.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Account().getUserEmail();
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: size.height * 0.75,
        width: size.width * 0.75,
        child: Container(
          decoration: BoxDecoration(
              color: greyBackground,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              )),
          child: Column(children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "บัญชี",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      Account.userEmail,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Baby_profile()));
              },
              leading: Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text(BabyInfo.nickname),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('ออกจากระบบ '),
                        content: Text('คุณต้องการออกจากระบบใช่ไหม ?'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                FirebaseAuth firebaseAuth =
                                    FirebaseAuth.instance;
                                await firebaseAuth.signOut().then((response) {
                                  MaterialPageRoute materialPageRoute =
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SignIn());
                                  Navigator.of(context).pushAndRemoveUntil(
                                      materialPageRoute,
                                      (Route<dynamic> route) => false);
                                });
                              },
                              child: Text('OK'))
                        ],
                      );
                    });
              },
              leading: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text("ออกจากระบบ"),
            ),
          ]),
        ),
        // ),
      ),
    );
  }
}
