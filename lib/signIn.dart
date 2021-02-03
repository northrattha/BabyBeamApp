import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'components/rounded_button.dart';
import 'components/already_have_an_account_check.dart';
import 'components/rounded_input_field.dart';
import 'components/rounded_password_field.dart';
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

  String email, password;
  final auth = FirebaseAuth.instance;

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(email: emailstr, password: passwordstr)
        .then((response) {
      print('success');
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => HomePage());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }).catchError((response) {
      // กรอกผิด เมลไม่มี ว่าง พาสเวิดผิด
      String title = response.code;
      String message = response.message;
      // myAlert(title, message);
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
          }
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
        prefixIcon: Icon(Icons.lock, color: greenbeam),
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
          return 'Password Must More than 6 Charactor';
        } else {
          return null;
        }
      },
    );
  }

  Widget signIn() {
    return Container(
      width: size.width * 0.8,
      child: RaisedButton(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        color: greenbeam,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(29),
        ),
        onPressed: () {
          formKey.currentState.save(); // onsaved will work
          print('email = $emailstr, key = $passwordstr');
          checkAuthen();
        },
        child: txt2w('ลงชื่อเข้าใช้'),
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
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SvgPicture.asset(
//               'images/sign_in.svg',
//               height: size.width * 0.5,
//             ),
//             SizedBox(height: size.width * 0.025),
//             RoundedInputField(
//               hintText: 'อีเมล',
//               keyboardType: TextInputType.emailAddress,
//               onChanged: (value) {
//                 setState(
//                   () {
//                     email = value.trim();
//                   },
//                 );
//               },
//             ),
//             RoundedPasswordField(
//               onChanged: (value) {
//                 setState(
//                   () {
//                     password = value.trim();
//                   },
//                 );
//               },
//             ),
//             SizedBox(height: size.width * 0.025),
//             RoundedButton(
//               text: 'ลงชื่อเข้าใช้',
//               press: () {
//                 auth.signInWithEmailAndPassword(
//                     email: email, password: password);
//                 Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => HomePage()));
//               },
//             ),
//             SizedBox(height: size.width * 0.05),
//             AlreadyHaveAnAccountCheck(
//               press: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return Register();
//                     },
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

    size = MediaQuery.of(context).size;
    // build is a method that ทำงานเป็นตัวแรก
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(children: [Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             SizedBox(height: 100,),
            logo('images/sign_in.svg', size),
            SizedBox(height: size.width * 0.025),
            Container(
              width:  size.width * 0.8,
              margin: EdgeInsets.symmetric(vertical: 10),
      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Form(
                key: formKey,
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
                    signIn(),
                    signUp(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),],)
    );
  }
}
