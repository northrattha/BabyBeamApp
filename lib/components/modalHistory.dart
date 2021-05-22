import 'package:BabyBeamApp/model/historyVac.dart';
import 'package:flutter/material.dart';
import '../myStyle.dart';

class ModalHistory extends StatefulWidget {
  final HistoryVac histList;
  final Color colormodal;
  final Color colorbuttom;
  const ModalHistory({
    Key key,
    this.colormodal,
    this.colorbuttom,
    this.histList,
  }) : super(key: key);

  @override
  _ModalHistoryState createState() => _ModalHistoryState();
}

class _ModalHistoryState extends State<ModalHistory> {
  final formKey = GlobalKey<FormState>();
  String date, symptom;
  bool tcVisibility = false;
  // VaccineList modelVac;
  HistoryVac modelHist;
  Color primary = orangeBackGroundColor2;
  @override
  void initState() {
    super.initState();
    modelHist = widget.histList;
  }

  Widget symptombox() {
    return Container(
      width: 200,
      height: 39,
      padding: EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70),
        color: bage,
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: redBurgandy),
          SizedBox(
            width: 13,
          ),
          Text(modelHist.symptom==""?"ไม่มีอาการผิดปกติ":modelHist.symptom)
        ],
      ),
    );
  }

  Widget datebox() {
    return Container(
      width: 200,
      height: 39,
      padding: EdgeInsets.only(left: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70),
        color: white,
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded, color: primary),
          SizedBox(
            width: 13,
          ),
          Center(child: Text(modelHist.day),),
        ],
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
                          // color: redbeam,
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                modelHist.key == 'วัคซีนเสริม'
                                    ? modelHist.name
                                    : modelHist.key,
                                style: TextStyle(color: Colors.black87, fontSize: 30),
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
                            SizedBox(
                              height: 8,
                            ),
                            datebox(),
                            SizedBox(
                              height: 11,
                            ),
                            symptombox(),
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
