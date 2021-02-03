import 'package:flutter/material.dart';

class ImageProfile extends StatelessWidget {

  final double size;
  const ImageProfile({
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: size+45,
                height: size+45,
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
            ],
          )
        ],
      );
  }
}