import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/datePicker.dart';
import 'components/rounded_button.dart';
import 'components/rounded_input_field.dart';
import 'components/small_rounded_button.dart';
import 'components/text_field_container.dart';
import 'home.dart';
import 'myStyle.dart';

class AddBaby extends StatefulWidget {
  AddBaby({Key key}) : super(key: key);

  @override
  _AddBabyState createState() => _AddBabyState();
}

class _AddBabyState extends State<AddBaby> {
  final formKey = GlobalKey<FormState>(); // get email & password value
  String name, sex, birthDate, firstName, lastName, nickName;
  int selectedIndex;

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> insertValue() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['nickname'] = nickName;
    map['id'] = user.uid;
    map['sex'] = sex;
    map['birthDate'] = birthDate;
    map['ageY'] = PickerState.ageY;
    map['ageM'] = PickerState.ageM;
    map['ageD'] = PickerState.ageD;

    await firebaseFirestore
        .collection('baby_profile')
        .doc("00000000000")
        .set(map)
        .then((value) {
      print('Insert Success');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Form(
          key: formKey,
          child: Container(
            margin: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'images/user128.png',
                    ),
                  ),
                ),
                SizedBox(height: size.width * 0.025),
                RoundedInputField(
                  color: orangeBackGroundColor,
                  iconColor: orangeButtonColor,
                  hintText: 'ชื่อเล่น',
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    nickName = value.trim();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150,
                      child: RoundedInputField(
                        color: orangeBackGroundColor,
                        iconColor: orangeButtonColor,
                        hintText: 'ชื่อ',
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          firstName = value.trim();
                        },
                      ),
                    ),
                    Container(
                      width: 150,
                      child: RoundedInputField(
                        color: orangeBackGroundColor,
                        iconColor: orangeButtonColor,
                        hintText: 'นามสกุล',
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          lastName = value.trim();
                        },
                      ),
                    ),
                  ],
                ),
                TextFieldContainer(
                  color: orangeBackGroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today_rounded,
                        color: orangeButtonColor,
                      ),
                      Text(
                        'วันเกิด',
                        style: TextStyle(fontFamily: 'Medium'),
                      ),
                      Picker(
                        backgroundcolor: Colors.white,
                        fontColor: Colors.black,
                        width: 177,
                      ),
                    ],
                  ),
                ),
                TextFieldContainer(
                  color: orangeBackGroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.sentiment_satisfied_rounded,
                        color: orangeButtonColor,
                      ),
                      Text(
                        'เพศ',
                        style: TextStyle(fontFamily: 'Medium'),
                      ),
                      SmallRoundedButton(
                        text: 'หญิง',
                        font: 'Medium',
                        textColor:
                            selectedIndex == 0 ? Colors.white : Colors.black,
                        color: selectedIndex == 0
                            ? orangeButtonColor
                            : Colors.white,
                        press: () {
                          changeIndex(0);
                          sex = 'หญิง';
                        },
                      ),
                      SmallRoundedButton(
                        text: 'ชาย',
                        font: 'Medium',
                        textColor:
                            selectedIndex == 1 ? Colors.white : Colors.black,
                        color: selectedIndex == 1
                            ? orangeButtonColor
                            : Colors.white,
                        press: () {
                          changeIndex(1);
                          sex = 'ชาย';
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.width * 0.025),
                RoundedButton(
                  color: orangeButtonColor,
                  text: 'เพิ่มลูก',
                  press: () {
                    birthDate = PickerState.date_picker;
                    insertValue();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Home()),
                        (Route route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
