import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'myStyle.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>(); // get email & password value
  String emailstr, passwordstr;
  bool _obscureText = true;
  Size size;
  String title;
  String email, password;
  final auth = FirebaseAuth.instance;

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(email: emailstr, password: passwordstr)
        .then((response) {
      print('success');
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }).catchError((response) {
      setState(() {
        title = response.code;
      });
    });
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
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
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  Widget emailfield() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: greenbeam),
        filled: true,
        fillColor: greenBackGroundColor,
        hintText: 'อีเมล',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: grayBackGroundColor, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: greenbeam, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      onSaved: (String value) {
        emailstr = value.trim();
      },
    );
  }

  Widget passwordfield() {
    return TextFormField(
      autofocus: false,
      obscureText: _obscureText,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: greenBackGroundColor,
        hintText: 'รหัสผ่าน',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: grayBackGroundColor, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: greenbeam, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        prefixIcon: Icon(Icons.lock, color: greenbeam),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: greenbeam,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
          ),
        ),
      ),
      onSaved: (String value) {
        passwordstr = value.trim();
      },
    );
  }

  Widget signIn() {
    return Container(
      width: size.width * 0.8,
      child: RaisedButton(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        color: greenbeam,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(29),
        ),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            checkAuthen();
          }
        },
        child: Text(
          "ลงชื่อเข้าใช้",
          style:
              TextStyle(fontFamily: 'Bold', color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget signUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ยังไม่ได้เป็นสมาชิก ?'),
        TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Register()));
          },
          child: Text(
            'สมัครสมาชิก',
            style: TextStyle(color: orangebeam),
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
              'images/sign_in.svg',
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
                            'กรุณาตรวจสอบอีเมลและรหัสผ่านอีกครั้ง',
                            style: TextStyle(color: redbeam),
                          )
                        : Text(''),
                    SizedBox(height: size.width * 0.025),
                    emailfield(),
                    SizedBox(height: size.width * 0.025),
                    passwordfield(),
                    SizedBox(height: size.width * 0.025),
                    signIn(),
                    signUp(),
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
