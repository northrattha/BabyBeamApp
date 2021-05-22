import 'package:BabyBeamApp/home.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/datePicker.dart';
import 'components/rounded_button.dart';
import 'components/rounded_input_field.dart';
import 'components/small_rounded_button.dart';
import 'components/text_field_container.dart';
import 'myStyle.dart';

class BabyProfile extends StatefulWidget {
  BabyProfile({Key key}) : super(key: key);

  @override
  _BabyProfileState createState() => _BabyProfileState();
}

DateTime dateTime;

class _BabyProfileState extends State<BabyProfile> {
  final formKey = GlobalKey<FormState>(); // get email & password value
  String name, sex, birthDate, firstName, lastName, nickName;

  int selectedIndex;
  @override
  void initState() {
    super.initState();
    if (BabyInfo.sex == 'หญิง') {
      selectedIndex = 0;
    } else
      selectedIndex = 1;
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> upDateValue() async {
    print('dd : ${PickerState.date_picker}'); 
    if (nickName != null && nickName != BabyInfo.nickname) {
      FirebaseFirestore.instance
          .doc('/baby_profile/${BabyInfo.userID}')
          .update({
        'nickname': nickName,
      }).then((value) {
        print('Update Symptom Success');
      });
    }

    if (firstName != null && firstName != BabyInfo.firstname) {
      FirebaseFirestore.instance
          .doc('/baby_profile/${BabyInfo.userID}')
          .update({
        'first_name': firstName,
      }).then((value) {
        print('Update Symptom Success');
      });
    }

    if (lastName != null && lastName != BabyInfo.lastname) {
      FirebaseFirestore.instance
          .doc('/baby_profile/${BabyInfo.userID}')
          .update({
        'last_name': lastName,
      }).then((value) {
        print('Update Symptom Success');
      });
    }

    if (sex != null && sex != BabyInfo.sex) {
      FirebaseFirestore.instance
          .doc('/baby_profile/${BabyInfo.userID}')
          .update({
        'sex': sex,
      }).then((value) {
        print('Update Symptom Success');
      });
    }

    if (PickerState.date_picker != BabyInfo.birthDay &&
        PickerState.date_picker != null) {
      FirebaseFirestore.instance
          .doc('/baby_profile/${BabyInfo.userID}')
          .update({
        'birthDate': PickerState.date_picker,
        'ageY': PickerState.ageY,
        'ageM': PickerState.ageM,
        'ageD': PickerState.ageD,
      }).then((value) {
        print('Update PickerState.date_picker Success');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Container(
                margin: EdgeInsets.all(10),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: orangeButtonColor,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                ),
              ),
            ),
            Form(
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
                      input: nickName == null ? BabyInfo.nickname : nickName,
                      color: orangeBackGroundColor,
                      iconColor: orangeButtonColor,
                      hintText: 'ชื่อเล่น',
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        print(value);
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
                            input: firstName == null
                                ? BabyInfo.firstname
                                : firstName,
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
                            input:
                                lastName == null ? BabyInfo.lastname : lastName,
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
                            showText: BabyInfo.birthDay,
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
                            textColor: selectedIndex == 0
                                ? Colors.white
                                : Colors.black,
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
                            textColor: selectedIndex == 1
                                ? Colors.white
                                : Colors.black,
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
                      text: 'แก้ไขข้อมูล',
                      press: () {
                        birthDate = PickerState.date_picker;
                        upDateValue();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
