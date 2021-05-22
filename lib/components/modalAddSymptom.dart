import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/symptom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../myStyle.dart';

class ModalAddSymptom extends StatefulWidget {
  final Color colormodal;
  final Color colorbuttom;
  final String type;
  final List hist;

  const ModalAddSymptom(
      {Key key, this.colormodal, this.colorbuttom, this.type, this.hist})
      : super(key: key);
  @override
  _ModalAddSymptomState createState() => _ModalAddSymptomState();
}

class _ModalAddSymptomState extends State<ModalAddSymptom> {
  final formKey = GlobalKey<FormState>();
  String name, title;
  bool error;
  bool haveData;
  List dataList;

  @override
  void initState() {
    super.initState();
    dataList = widget.hist;
    error = false;

    if (widget.type == 'drug') {
      title = 'การแพ้ยา';
    } else if (widget.type == 'food') {
      title = 'การแพ้อาหาร';
    } else
      title = 'โรคประจำตัว';
  }

  Future<void> insertValue() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['name'] = name;
    await firebaseFirestore
        .collection(
            'baby_profile/${BabyInfo.userID}/medical_problems/medical_problems/${widget.type}')
        .doc()
        .set(map)
        .then((value) {
      print('Insert Success');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Symptom()));
    });
  }

  Widget saveButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: bage,
      onPressed: () async {
        formKey.currentState.save();
        if (name != "") {
          insertValue();
        
        } else {
          setState(() {
            if (name == "") {
              error = true;
            }
          });
        }
        // }
      },
      child: Text('บันทึก'),
    );
  }

  Widget history() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: bage,
      onPressed: () {},
      child: Text('ประวัติ'),
    );
  }

  Widget field() {
    return Container(
      width: 300,
      height: 55,
      padding: EdgeInsets.only(top: 5, bottom: 10),
      child: TextFormField(
          // initialValue: '',
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          maxLines: null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            filled: true,
            fillColor: white,
            prefixIcon: Icon(Icons.add_moderator, color: redBurgandy),
            hintText: '                   ระบุชื่อ',
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
              return 'กรุณากรอกข้อมูล';
            } else {
              return null;
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
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
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // width: 120 ,
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  field(),
                  Visibility(
                    visible: error,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          '** กรุณากรอกข้อมูล',
                          style: TextStyle(color: redBurgandy, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  saveButton(),

                  // saveButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
