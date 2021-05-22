import 'package:BabyBeamApp/myStyle.dart';
import 'package:flutter/material.dart';

class ButtonBackPages extends StatelessWidget {
  final Function press;
  const ButtonBackPages({
    Key key,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton(
          onPressed: press,
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
          color: greenBackGroundColor,
        ),
      ),
    );
  }
}
