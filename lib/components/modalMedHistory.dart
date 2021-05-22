import 'dart:math';
import 'package:BabyBeamApp/components/datePicker.dart';
import 'package:BabyBeamApp/medicalHistory.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../myStyle.dart';

class ModalMedHistory extends StatefulWidget {
  final Color colormodal;
  final Color colorbuttom;

  const ModalMedHistory({Key key, this.colormodal, this.colorbuttom})
      : super(key: key);
  @override
  _ModalMedHistoryState createState() => _ModalMedHistoryState();
}

class _ModalMedHistoryState extends State<ModalMedHistory> {
  final formKey = GlobalKey<FormState>();
  String date, detail, title;
  bool dateError, vacError;

  @override
  void initState() {
    super.initState();
    dateError = false;
    vacError = false;
  }

  Future<void> insertValue() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['day'] = date;
    map['title'] = title;
    map['detail'] = detail;
    map['time'] = PickerState.date_picker2;

    await firebaseFirestore
        .collection(
            '/baby_profile/${BabyInfo.userID}/medical_problems/medical_history/medical_history')
        .doc()
        .set(map)
        .then((value) {
      print('Insert Success');
       Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => Medicalhistory()));
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
    print(title);
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: greenbeam,
      onPressed: () {
        // if(formKey.currentState.validate()){
        formKey.currentState.save();
        date = PickerState.date_picker;
        if (date != null && title != "") {
          insertValue();
        } else {
          setState(() {
            if (date == null) {
              dateError = true;
            }
            if (title == "") {
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
            prefixIcon: Icon(Icons.add_moderator, color: greenbeam),
            hintText: '     การรักษา',
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
            title = value.trim();
          },
          validator: (String title) {
            if (title == "") {
              // return 'Please Check Your Email';
              return 'กรุณากรอกข้อมูล';
            } else {
              return null;
            }
          }),
    );
  }

  Widget symptomField() {
    // const maxLine = 5;
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
          prefixIcon: Icon(Icons.warning_rounded, color: greenbeam),
          hintText: '       รายละเอียด',
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
          detail = value;
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
                color: grayBackGroundColor,
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
                                "การรักษา",
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
                                        '** กรุณากรอกข้อมูล',
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
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Text(
                                        '** กรุณากรอกวันที่',
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
