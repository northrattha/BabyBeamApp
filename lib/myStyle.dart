import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Mystyle {

  Text textButtonModal(String text) => Text(
        text,
        style: TextStyle(fontSize: 23.0, color: white),
      );

  Text textButtonHeadbar(String text) => Text(
        text,
        style: TextStyle(fontSize: 30.0, color: Colors.black),
      );
}

const Color redbeam = Color.fromRGBO(250, 136, 126, 1.0);
const Color bluebeam01 = Color.fromRGBO(244, 249, 255, 1.0);
const Color greenbeam = Color.fromRGBO(15, 194, 191, 1.0);
const Color bluebeam02 = Color.fromRGBO(56, 130, 248, 1.0);
const Color orangebeam = Color.fromRGBO(255, 158, 72, 1.0);
const Color white = Color.fromRGBO(255, 255, 255, 1.0);
const Color nocolor = Color.fromRGBO(0, 0, 0, 0);
const Color greenDark = Color.fromRGBO(8, 86, 88, 1.0);
const Color purple = Color.fromRGBO(188, 170, 220, 1.0);
const Color blue_Grey = Color.fromRGBO(206, 220, 232, 1.0);
const Color greyBackground = Color.fromRGBO(235, 238, 243, 1.0);
const Color greyLight = Color.fromRGBO(169, 174, 180, 1.0);
const Color greyDark = Color.fromRGBO(111, 118, 125, 1.0);

const bluePastel = Color(0xFFb3c8dd);
const greenPastel = Color(0xff99bfb8);
const bluePastel2 = Color(0xFFace7ff);
const yellowPastel = Color(0xFFf7d8a8);
const purplePastel = Color(0xFFdacee3);

const orangeBackGroundColor = Color(0x42F7B27B);
const orangeBackGroundColor2 = Color(0xffffc79d);
const orangeButtonColor = Color(0xFFFFA25B);
const orangeButtonColor2 = Color(0xFFffc79d);
// Rad
const radBackGroundColor = Color(0x42FF725C);
const radButtonColor = Color(0xFFDD4D42);
const redBurgandy = Color(0xFF72434B);
const redBurgandyButton = Color(0xff5b363c);
// Orange
const orangebeampastel = Color(0xFFFFCD79);
// yellow
const yelloMastard = Color(0xFFFFC857);
// Green
const greenBackGroundColor = Color(0x4251E3C9);
const greenButtonColor = Color(0xFF00CFAA);
const Color greenlight = Color.fromRGBO(137, 241, 182, 1.0);
const greenbeampastel = Color(0xFFA2E2C4);
// Purple
const purpleBackGroundColor = Color(0x8A8467BE);
const purpleButtonColor = Color(0xFF5C34A9);
const purpleTransparent = Color(0xFFe0d8ef);
// Gray
const grayBackGroundColor = Color(0xFFF8F8F8);
const grayShadowColor = Color(0xFFE6E6E6);
const grayBottomColor = Color(0xFFBBBBBB);
// blue

const navyblue = Color(0xFF425e83);
// clubhouse
const bage = Color(0xFFf1eee4);
const nav = Color(0xFF5376a4);
// Cadet Blue Crayola
const cadetBlueCrayola = Color(0xFFA2B2C4);


const alabaster = Color(0xFFF1EEE4);

Widget txtSmallHeader(txt,Color color){
  return Column(
    children: [
      Text(txt,style: TextStyle(color: color,fontSize: 20,fontWeight: FontWeight.bold),),
    ],
  );
}

Widget headTextField(txt) => Text(
      txt,
      style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold,fontSize: 16),
    );

Widget line(thinkness) {
  return Container(
    child: Divider(
      color: Colors.white,
      thickness: thinkness,
      height: 4,
    ),
  );
}

Widget txt2(String txt) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: 18,
      color: Colors.grey.shade800,
    ),
  );
}

Widget txt2w(String txt) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
  );
}

Widget txt3(String txt) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: 16,
      color: Colors.grey.shade800,
    ),
  );
}

Widget logo(String image,Size size) {
    return Container(
      padding: EdgeInsets.all(30),
      child: SvgPicture.asset(
        image,
        height: size.width * 0.5,
      ),
    );
  }

