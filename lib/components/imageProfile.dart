import 'package:BabyBeamApp/home.dart';
import 'package:flutter/material.dart';

class ImageProfile extends StatelessWidget {
  final double size;
  final Color color;
  const ImageProfile({
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            GestureDetector(
              child: Container(
                width: size + 45,
                height: size + 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.5),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/user128.png'),
                    ),
                  ),
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
              },
            ),
          ],
        )
      ],
    );
  }
}

Widget imageL() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        children: [
          GestureDetector(
            child: Container(
              width: 140,
              height: 140, // 80+60
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white54,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('images/user128.png'),
                  ),
                ),
              ),
            ),
            onTap: () {
            },
          ),
        ],
      )
    ],
  );
}
