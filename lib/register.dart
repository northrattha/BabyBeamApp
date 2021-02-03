import 'package:BabyBeamApp/baby_profile.dart';
import 'package:BabyBeamApp/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'myStyle.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
// Explicit
  final formkey = GlobalKey<FormState>();
  String namestr, emailstr, passwordstr;
  bool _obscureText = true;
  Size size;
  Future<void> insertValue() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;

    Map<String, dynamic> map = Map();
    map['family'] = namestr;
    // map['m1'] = uid;

    await firebaseFirestore
        .collection('baby_profile')
        .doc(user.uid)
        .set(map)
        .then((value) {
      print('Insert Success');
    });
  }

// Method

  Widget emailfield() {
    return Container(
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: orangeBackGroundColor,
            prefixIcon: Icon(Icons.person, color: orangeButtonColor),
            hintText: 'อีเมล',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: grayBackGroundColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            // labelText: 'อีเมล',
          ),
          onSaved: (String value) {
            emailstr = value.trim();
          },
          validator: (String email) {
            if (!((email.contains('@')) && (email.contains('.')))) {
              // return 'Please Check Your Email';
              return 'กรุณาตรวจสอบอีเมลอีกครั้ง';
            } else {
              return null;
            }
          }),
    );
  }

  Widget passwordfield() {
    return TextFormField(
      autofocus: false,
      obscureText: _obscureText,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: orangeBackGroundColor,
        prefixIcon: Icon(Icons.lock, color: orangeButtonColor),
        hintText: 'รหัสผ่าน',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: grayBackGroundColor, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        // icon: Icon(Icons.lock, color: greenbeam),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
          ),
        ),
      ),
      onSaved: (String value) {
        passwordstr = value.trim();
      },
      validator: (String key) {
        if (key.length < 6) {
          // return 'Password Must More than 6 Charactor';
          return 'กรุณากรอกรหัสผ่านอย่างน้อย 6 หลัก';
        } else {
          return null;
        }
      },
    );
  }

  Widget signUp() {
    return Container(
      width: size.width * 0.8,
      child: RaisedButton(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        color: orangeButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(29),
        ),
        onPressed: () {
          print('sign up');
          if (formkey.currentState.validate()) {
            formkey.currentState.save();
            print('name :$namestr, email :$emailstr, password :$passwordstr');
            registerThread();
          }
        },
        child: txt2w('สมัคร'),
      ),
    );
  }

  Future<void> registerThread() async {
    print('object');
    FirebaseAuth firebaseAuth =
        FirebaseAuth.instance; // ใช้คอลเมตอดที่อยู่ในไลบารี่มาทำงาน
    await firebaseAuth
        .createUserWithEmailAndPassword(email: emailstr, password: passwordstr)
        .then((response) {
      print('Created for email :$emailstr'); // สมัครสำเร็จ
      insertValue();
      setupDisplayName();
    }).catchError((response) {
      String title = response.code; // code is หัวข้อที่ผิด
      String message = response.message;
      print('title = $title, message = $message');
      aleart(title, message);
    });
    // then is response if finish
  }

  Future<void> setupDisplayName() async {
    // สร้างเทรดที่ไม่มีการรีเทิรนค่ากลับ
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    if (user != null) {
      user.updateProfile(displayName: namestr);
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Baby_profile()),
        (Route<dynamic> route) => false);
  }

  void aleart(String title, String message) {
    showDialog(
        context:
            context, // เชื่อมต่อ stateless ของที่นี่ เพื่อดึง title กับ message มาแสดง
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.add_alert,
                color: redbeam,
              ),
              title: Text(
                title,
                style: TextStyle(color: redbeam),
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Widget signIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('มีบัญชีอยู่แล้ว ?'),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignIn(),
              ),
            );
          },
          child: Text(
            'ลงชื่อเข้าใช้',
            style: TextStyle(color: greenbeam),
          ),
        ),
      ],
    );
  }

  Widget logo() {
    return Container(
      padding: EdgeInsets.all(30),
      child: SvgPicture.asset(
        'images/sign_up.svg',
        height: size.width * 0.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body:  Stack(
          children: <Widget>[
            Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  logo(),
                  SizedBox(height: size.width * 0.025),
                  Container(
                    width: size.width * 0.8,
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          // content(),
                          emailfield(),
                          SizedBox(
                            height: 10,
                          ),
                          passwordfield(),
                          SizedBox(
                            height: 50,
                          ),
                          signUp(),
                          signIn(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // your body code
          ],
        ),
     

      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       logo(),
      //       SizedBox(height: size.width * 0.025),
      //       Container(
      //         width: size.width * 0.8,
      //         child: Form(
      //           key: formkey,
      //           child: Column(
      //             children: [
      //               // content(),
      //               emailfield(),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               passwordfield(),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               signUp(),
      //               signIn(),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
