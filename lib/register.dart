import 'package:BabyBeamApp/babyProfileOld.dart';
import 'package:BabyBeamApp/signIn.dart';
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
  final formKey = GlobalKey<FormState>();
  String emailstr, passwordstr;
  bool _obscureText = true;
  static String title;
  Size size;

// Method
  @override
  void initState() {
    super.initState();
    title = null;
  }

  Future<void> registerThread() async {
    print('object');
    FirebaseAuth firebaseAuth =
        FirebaseAuth.instance; // ใช้คอลเมตอดที่อยู่ในไลบารี่มาทำงาน
    await firebaseAuth
        .createUserWithEmailAndPassword(email: emailstr, password: passwordstr)
        .then((response) {
      print('Created for email :$emailstr'); // สมัครสำเร็จ
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Baby_profile()),
          (Route<dynamic> route) => false);
    }).catchError((response) {
      print(response.code);
      print('Title : $title');
      if (title == null) {
        if (response.code == 'email-already-in-use') {
          title = 'อีเมลนีถูกใช้ไปแล้ว กรุณาลงชื่อเข้าใช้';
        } else
          title = response.code;
      }
      setState(() {});
      print('title = $title');
      // aleart(title, message);
    });
  }

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
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: orangeButtonColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          onSaved: (String value) {
            emailstr = value.trim();
          },
          validator: (String email) {
            if (!((email.contains('@')) && (email.contains('.')))) {
              // return 'Please Check Your Email';
              print('error');
              title = 'กรุณาตรวจสอบอีเมลอีกครั้ง';
              // return 'กรุณาตรวจสอบอีเมลอีกครั้ง';
            } else {
              title = null;
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
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: orangeButtonColor, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: orangeButtonColor,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
          ),
        ),
      ),
      onSaved: (String value) {
        passwordstr = value.trim();
      },
      validator: (String key) {
        if (title == null && key.length < 6) {
          title = 'กรุณากรอกรหัสผ่านอย่างน้อย 6 หลัก';
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
        padding: EdgeInsets.only(top: 15, bottom: 15),
        color: orangeButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(29),
        ),
        onPressed: () {
          print('sign up');
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            print('email :$emailstr, password :$passwordstr');
            registerThread();
          }
        },
        child: Text(
          "สมัคร",
          style:
              TextStyle(fontFamily: 'Bold', color: Colors.white, fontSize: 16),
        ),
      ),
    );
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
              MaterialPageRoute(builder: (context) => SignIn()),
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

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'images/sign_up.svg',
              height: size.width * 0.5,
            ),
            Container(
              width: size.width * 0.8,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: size.width * 0.025),
                    title != null
                        ? Text(
                            title,
                            style: TextStyle(color: redbeam),
                          )
                        : Text(''),
                    SizedBox(height: size.width * 0.025),
                    emailfield(),
                    SizedBox(height: size.width * 0.025),
                    passwordfield(),
                    SizedBox(height: size.width * 0.025),
                    signUp(),
                    signIn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
