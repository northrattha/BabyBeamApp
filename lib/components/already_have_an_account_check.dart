import 'package:BabyBeamApp/myStyle.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  final textColor;
  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
    this.textColor = orangeButtonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? 'ยังไม่ได้เป็นสมาชิก ? ' : 'มีบัญชีอยู่แล้ว ? ',
          style: TextStyle(fontFamily: 'Medium'),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? 'สมัครสมาชิก' : 'ลงชื่อเข้าใช้',
            style: TextStyle(
              fontFamily: 'Bold',
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
