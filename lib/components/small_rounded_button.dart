import 'package:flutter/material.dart';

class SmallRoundedButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function press;
  const SmallRoundedButton({
    Key key,
    this.press,
    this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: StadiumBorder(),
      color: Colors.white,
      onPressed: press,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Bold',
              fontSize: 16,
            ),
          ),
          Icon(icon),
        ],
      ),
    );
  }
}
