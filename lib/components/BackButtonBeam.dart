import 'package:flutter/material.dart';

class BackButtonBeam extends StatelessWidget {
  final Color background;
  final Color color = Colors.white;
  const BackButtonBeam({color, this.background});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: background.withOpacity(0.7)),
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: color,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
