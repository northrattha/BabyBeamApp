import 'package:BabyBeamApp/abnormal.dart';
import 'package:BabyBeamApp/components/datePicker.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/graphSympHist.dart';
import 'myStyle.dart';

class AddAbnormal extends StatefulWidget {
  final Color colormodal;
  final Color colorbuttom;
  final String type;

  const AddAbnormal({Key key, this.colormodal, this.colorbuttom, this.type})
      : super(key: key);
  @override
  _AddAbnormalState createState() => _AddAbnormalState();
}

class _AddAbnormalState extends State<AddAbnormal> {
  final formKey = GlobalKey<FormState>();
  String name, title;
  bool error, errorsym;
  bool haveData;
  List dataList;
  Size size;
 bool more;

  List<String> tags = [];

  List<String> options = new List();

  @override
  void initState() {
    super.initState();
    readData();
    error = false;
    errorsym = false;
    more = false;
  }

  Future<void> readData() async {
    final QuerySnapshot drugresult =
        await FirebaseFirestore.instance.collection('/symptoms').get();
    final List<DocumentSnapshot> documents = drugresult.docs;
    documents.forEach((data) {
      String name = data.get('name');
      setState(() {
        options.add(name);
      });
    });
  }

  Future readData2() async {
    BabyInfo.graphSympHist.clear();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('/baby_profile/${BabyInfo.userID}/graph')
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) {
      Map<String, dynamic> map = data.data();
      GraphSympHist model = GraphSympHist.fromMap(map);
      print(model);
      setState(() {
        BabyInfo.graphSympHist.add(model);
      });
      print('end : ${BabyInfo.graphSympHist}');
      if (BabyInfo.graphSympHist.length == documents.length) {
        // seriesList = _createData();
        setState(() {
          // seriesList = _createData();
        });
      }
    });
  }

  Future<Null> delay(int milliseconds) {
    return new Future.delayed(new Duration(milliseconds: milliseconds));
  }

  Future<void> insertValue() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['symps'] = tags;
    map['time'] = PickerState.date_picker2;
    map['date'] = PickerState.date_picker;
    await firebaseFirestore
        .collection('baby_profile/${BabyInfo.userID}/symptom/')
        .doc()
        .set(map)
        .then((value) => print('Insert Success'));

    for (var symp in tags) {
      await FirebaseFirestore.instance
          .collection('/baby_profile/${BabyInfo.userID}/graph/')
          .doc(symp)
          .get()
          .then((value) {
        if (value.data() == null) {
          Map<String, dynamic> map2 = Map();
          map2['number'] = 1;
          map2['symp'] = symp;

          firebaseFirestore
              .collection('baby_profile/${BabyInfo.userID}/graph/')
              .doc(symp)
              .set(map2)
              .then((value) => print('Insert Success'));
        } else {
          int i = value.get('number');
          i = i + 1;
          firebaseFirestore
              .collection('/baby_profile/${BabyInfo.userID}/graph/')
              .doc(symp)
              .update({
            'number': i,
          }).then((value) async {
            print('Update graph');
          });
        }
      });
    }
    readData2();
    await delay(200);
    return Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => Abnormal()));
  }

  Widget saveButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: bage,
      onPressed: () async {
        formKey.currentState.save();
        if (PickerState.date_picker == null) {
          setState(() {
            error = true;
          });
        } else {
          if (tags.length != 0) {
            insertValue();
            await delay(200);
          } else {
            setState(() {
              errorsym = true;
            });
          }
        }
      },
      child: Text('บันทึก'),
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
            hintText: '                   อื่นๆ',
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
  Widget select() {
    return Container(
      // color: redBurgandy,
      alignment: Alignment.center,
      // padding: EdgeInsets.all(20),
      width: 250,
      child: ChipsChoice<String>.multiple(
        wrapped: true,
        value: tags,
        // onChanged: (val) => setState(() => tags = val),
        onChanged: (val){
          setState(() {
          tags = val;
          //  if(tags=='อื่น ๆ'){
          //     more = true;      
          // }
        });},
        choiceItems: C2Choice.listFrom<String, String>(
          source: options,
          value: (i, v) => v,
          label: (i, v) => v,
        ),
        choiceActiveStyle: const C2ChoiceStyle(
          color: greenbeam,
          brightness: Brightness.dark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
                      'บันทึกอาการผิดปกติ',
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // field(),
                          Picker(
                            backgroundcolor: Colors.white,
                            fontColor: greyDark,
                            width: 200,
                            showText: "เลือกวันที่",
                          ),
                            Visibility(
                            visible: more,
                            // child: field(),
                            child: Text('data'),
                          ),
                          Visibility(
                            visible: error,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '** กรุณากรอกวันที่',
                                      style: TextStyle(
                                          color: redBurgandy, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: errorsym,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '** กรุณากรอกอาการ',
                                      style: TextStyle(
                                          color: redBurgandy, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          select(),
                          saveButton(),
                        ],
                      ),
                    ],
                  ),
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
