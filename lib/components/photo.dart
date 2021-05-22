import 'package:BabyBeamApp/myStyle.dart';
import 'package:flutter/material.dart';

class Photo extends StatelessWidget {
  const Photo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          alignment: Alignment.center,
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            color: greenBackGroundColor,
            shape: BoxShape.circle,
          ),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'images/user128.png',
            ),
          ),
        ),
      ),
    );
  }
}
