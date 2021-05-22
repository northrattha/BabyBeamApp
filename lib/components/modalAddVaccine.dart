import 'package:BabyBeamApp/components/datePicker.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/historyVac.dart';
import 'package:BabyBeamApp/model/vaccineList.dart';
import 'package:BabyBeamApp/vaccine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../myStyle.dart';

class ModalVaccine extends StatefulWidget {
  final VaccineList vacList;
  final HistoryVac histList;
  final Color colormodal;
  final Color colorbuttom;
  const ModalVaccine({
    Key key,
    this.colormodal,
    this.colorbuttom,
    this.vacList,
    this.histList,
  }) : super(key: key);

  @override
  _ModalVaccineState createState() => _ModalVaccineState();
}

class _ModalVaccineState extends State<ModalVaccine> {
  final formKey = GlobalKey<FormState>();
  String date, symptom;
  bool tcVisibility = false;
  VaccineList modelVac;
  HistoryVac modelHist;
  bool haveData;
  Color primary;
  Color buttonColor = orangeBackGroundColor2;
  Color fieldcolor = white;
  String userID;
  @override
  void initState() {
    super.initState();
    modelVac = widget.vacList;
    modelHist = widget.histList;
    primary = widget.colormodal;
    setState(() {
      BabyInfo.histID.contains(modelVac.id)
          ? haveData = true
          : haveData = false;
    });
  }

  Future<void> updateValue() async {
    String date = PickerState.date_picker;
    // print('Date ch : ${date}');
    // print("symptom change $symptom");
    // userID = Account.userID;
    if (symptom != modelHist.symptom) {
      FirebaseFirestore.instance
          .doc(
              '/baby_profile/${BabyInfo.userID}/vaccine_record/${modelHist.id}')
          .update({
        'symptom': symptom,
      }).then((value) {
        print('Update Symptom Success');
      });
    } else {
      print('Symptom same value');
    }
    if (date != null) {
      FirebaseFirestore.instance
          .doc('/baby_profile/${userID}/vaccine_record/${modelHist.id}')
          .update({
        'day': date,
        'time': PickerState.date_picker2,
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
    map['key'] = modelVac.key;
    map['name'] = modelVac.name;
    map['id'] = modelVac.id;
    map['symptom'] = symptom;
    map['time'] = PickerState.date_picker2;

    await firebaseFirestore
        .collection('baby_profile/${user.uid}/vaccine_record')
        .doc(modelVac.id)
        .set(map)
        .then((value) {
      print('Insert Success');
      Navigator.pop(context);

      // print('AFTER ADD : ${BabyInfo.vacHist}');
    });
  }

  Widget saveButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: buttonColor,
      onPressed: () {
        formKey.currentState.save();
        if (PickerState.date_picker != null) {
          print('Date : ${PickerState.date_picker}');
          date = PickerState.date_picker;
          insertValue();
          haveData = true;
          BabyInfo.vacHist.clear();
        } else {
          setState(() {
            tcVisibility = true;
          });
        }
        print('BD : $date');
      },
      child: Text('บันทึก'),
    );
  }

  Widget updateButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: buttonColor,
      onPressed: () {
        formKey.currentState.save();
        updateValue();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Vaccine()));
      },
      child: Text('แก้ไข'),
    );
  }

  Widget symptomField() {
    String input = haveData ? modelHist.symptom : "";
    return Container(
      width: 200,
      height: 55,
      padding: EdgeInsets.only(top: 5, bottom: 10),
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
          prefixIcon: Icon(Icons.warning_rounded, color: redBurgandyButton),
          hintText: haveData && widget.histList.symptom != ""
              ? modelHist.symptom
              : '       อาการ',
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
                                modelVac.key,
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 30),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                modelVac.note,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
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
                            Picker(
                              backgroundcolor: fieldcolor,
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
                            SizedBox(
                              height: 5,
                            ),
                            haveData != true ? saveButton() : updateButton(),
                          ],
                        ),
                      ],
                    ),
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
