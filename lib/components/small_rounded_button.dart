import 'package:flutter/material.dart';

class SmallRoundedButton extends StatelessWidget {
  final String text;
  final String font;
  final Color color, textColor;
  final IconData icon;
  final Function press;
  const SmallRoundedButton({
    Key key,
    this.press,
    this.text,
    this.icon,
    this.font = 'Bold',
    this.color = Colors.white,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: StadiumBorder(),
      color: color,
      onPressed: press,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontFamily: font,
              fontSize: 16,
            ),
          ),
          if (icon != null) Icon(icon),
        ],
      ),
    );
  }
}
