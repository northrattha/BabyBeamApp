import 'package:BabyBeamApp/components/datePicker.dart';
import 'package:BabyBeamApp/development.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/develop.dart';
import 'package:BabyBeamApp/model/historyDev.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../myStyle.dart';

class ModalDevelop extends StatefulWidget {
  final Develop devList;
  final HistoryDev histList;
  final Color colormodal;
  final Color colorbuttom;
  const ModalDevelop({
    Key key,
    this.colormodal,
    this.colorbuttom,
    this.devList,
    this.histList,
  }) : super(key: key);

  @override
  _ModalDevelopState createState() => _ModalDevelopState();
}

class _ModalDevelopState extends State<ModalDevelop> {
  final formKey = GlobalKey<FormState>();
  String date, note;
  bool tcVisibility = false;
  Develop modeldev;
  HistoryDev modelHist;
  bool haveData;
  Color primary;

  @override
  void initState() {
    super.initState();
    modeldev = widget.devList;
    modelHist = widget.histList;
    primary = widget.colormodal;
    setState(() {
      BabyInfo.histID.contains(modeldev.id)
          ? haveData = true
          : haveData = false;
    });
  }

  Future<void> updateValue() async {
    String date = PickerState.date_picker;
    // print('Date ch : ${date}');
    print("symptom change $note");
    // var userid = Account.userID;
    if (note != modelHist.symptom) {
      FirebaseFirestore.instance
          .doc(
              '/baby_profile/${BabyInfo.userID}/development_record/${modelHist.id}')
          .update({
        'symptom': note,
      }).then((value) {
        print('Update Symptom Success');
      });
    } else {
      print('Symptom same value');
    }
    if (date != null) {
      FirebaseFirestore.instance
          .doc(
              '/baby_profile/${BabyInfo.userID}/development_record/${modelHist.id}')
          .update({
        'day': date,
      }).then((value) {
        print('Update Day Success');
      });
    } else {
      print('Date same value');
    }
  }

  Future<void> insertValue() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['day'] = date;
    map['key'] = modeldev.key;
    map['name'] = modeldev.name;
    map['id'] = modeldev.id;
    map['note'] = note;
    map['time'] = PickerState.date_picker2;

    await firebaseFirestore
        .collection('baby_profile/${user.uid}/development_record')
        .doc(modeldev.id)
        .set(map)
        .then((value) {
      print('Insert Success');
      Navigator.pop(context);
    });
  }

  Widget saveButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: nav,
      onPressed: () {
        formKey.currentState.save();
        if (PickerState.date_picker != null) {
          print('Date : ${PickerState.date_picker}');
          date = PickerState.date_picker;
          insertValue();
          haveData = true;
          BabyInfo.devHist.clear();
        } else {
          setState(() {
            tcVisibility = true;
          });
        }
        print('BD : $date');
      },
      child: Text(
        'บันทึก',
        style: TextStyle(color: bage),
      ),
    );
  }

  Widget updateButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: yelloMastard,
      onPressed: () {
        formKey.currentState.save();
        updateValue();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Development()));
      },
      child: Text('แก้ไข'),
    );
  }

  Widget noteField() {
    String input = haveData ? modelHist.symptom : "";
    return Container(
      width: 200,
      height: 55,
      padding: EdgeInsets.only(top: 5, bottom: 10),
      // margin: EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        initialValue: input,
        autofocus: false,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          // isDense: true,
          filled: true,
          fillColor: bage,
          prefixIcon: Icon(Icons.warning_rounded, color: nav),
          hintText: haveData && widget.histList.symptom != ""
              ? modelHist.symptom
              : '     หมายเหตุ',
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
          note = value;
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      modeldev.name,
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Picker(
                      backgroundcolor: Colors.white,
                      fontColor: greyDark,
                      width: 200,
                      showText: haveData == true
                          ? widget.histList.day
                          : "เลือกวันที่",
                      input: haveData ? modelHist.day : null,
                    ),
                    Visibility(
                      visible: tcVisibility,
                      child: Column(
                        children: [
                          Text(
                            '** กรุณากรอกวันที่ทำได้',
                            style: TextStyle(color: redBurgandy, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    noteField(),
                    haveData != true ? saveButton() : updateButton(),

                    //   ],
                    // ),
                    // SizedBox(height: 15,),
                    // Text(
                    //   modelVac.note,
                    //   style: TextStyle(color: Colors.red, fontSize: 12),
                    // ),
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
