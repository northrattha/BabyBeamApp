import 'dart:math';
import 'package:BabyBeamApp/components/datePicker.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/vaccineList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../myStyle.dart';

class ModaladdOtherVacc extends StatefulWidget {
  // final List<VaccineList> vacList;
  final Color colormodal;
  final Color colorbuttom;

  const ModaladdOtherVacc({Key key, this.colormodal, this.colorbuttom})
      : super(key: key);
  @override
  _ModaladdOtherVaccState createState() => _ModaladdOtherVaccState();
}

class _ModaladdOtherVaccState extends State<ModaladdOtherVacc> {
  final formKey = GlobalKey<FormState>();
  String date, symptom, name, key;
  bool dateError, vacError;
  VaccineList modelVac;
  bool haveData;

  @override
  void initState() {
    super.initState();
    dateError = false;
    vacError = false;
  }

  Future<void> insertValue() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['day'] = date;
    map['key'] = "วัคซีนเสริม";
    map['name'] = name;
    map['id'] = generateRandomString(20);
    map['symptom'] = symptom;
    map['time'] = PickerState.date_picker2;

    // map['ageD'] = ageD;

    await firebaseFirestore
        .collection('baby_profile/${user.uid}/vaccine_record')
        .doc()
        .set(map)
        .then((value) {
      print('Insert Success');
      print('AFTER ADD : ${BabyInfo.vacHist}');
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Widget saveButton() {
    print(name);
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: orangeBackGroundColor2,
      onPressed: () {
        // if(formKey.currentState.validate()){
        formKey.currentState.save();
        date = PickerState.date_picker;
        if (date != null && name != "") {
          insertValue();
          BabyInfo.vacHist.clear();
          Navigator.pop(context);
        } else {
          setState(() {
            if (date == null) {
              dateError = true;
            }
            if (name == "") {
              vacError = true;
            }
          });
        }
        // }
      },
      child: Text('บันทึก'),
    );
  }

  Widget vaccineField() {
    // const maxLine = 5;
    return Container(
      width: 200,
      height: 55,
      padding: EdgeInsets.only(top: 5, bottom: 10),
      // margin: EdgeInsets.all(10),
      child: TextFormField(
          // initialValue: '',
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          maxLines: null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            isDense: true,
            filled: true,
            fillColor: bage,
            prefixIcon: Icon(Icons.add_moderator, color: redBurgandy),
            hintText: '     วัคซีนเสริม',
            hintStyle: TextStyle(fontSize: 15, height: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: grayBackGroundColor, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          onSaved: (String value) {
            name = value.trim();
          },
          validator: (String name) {
            if (name == "") {
              // return 'Please Check Your Email';
              return 'กรุณากรอกวัคซีนที่ได้รับ';
            } else {
              return null;
            }
          }),
    );
  }

  Widget symptomField() {
    return Container(
      width: 200,
      height: 55,
      padding: EdgeInsets.only(top: 5, bottom: 10),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          isDense: true,
          filled: true,
          fillColor: bage,
          prefixIcon: Icon(Icons.warning_rounded, color: redBurgandy),
          hintText: '       อาการ',
          hintStyle: TextStyle(fontSize: 15, height: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: grayBackGroundColor, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onSaved: (String value) {
          symptom = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              // height: 450,
              width: 500,
              decoration: BoxDecoration(
                color: widget.colormodal,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 30,
                          ),
                          onPressed: () => Navigator.pop(context),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "วัคซีนเสริม",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 30),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            vaccineField(),
                            Visibility(
                              visible: vacError,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        '** กรุณากรอกวัคซีนเสริมที่ได้รับ',
                                        style: TextStyle(
                                            color: redBurgandy, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Picker(
                              backgroundcolor: Colors.white,
                              fontColor: greyDark,
                              width: 200,
                              showText: "เลือกวันที่",
                            ),
                            Visibility(
                              visible: dateError,
                              child: Column(
                                children: [
                                  // Text(
                                  //   'กรุณากรอกวันที่รับวัคซีน',
                                  //   style: TextStyle(
                                  //       color: Colors.red, fontSize: 12),
                                  // ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Text(
                                        '** กรุณากรอกวันที่รับวัคซีน',
                                        style: TextStyle(
                                            color: redBurgandy, fontSize: 12),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            symptomField(),
                            saveButton()
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
