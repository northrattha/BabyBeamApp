import 'package:BabyBeamApp/model/historyDev.dart';
import 'package:flutter/material.dart';
import '../myStyle.dart';

class ModalDevHistory extends StatefulWidget {
  final HistoryDev histList;
  final Color colormodal;
  final Color colorbuttom;
  const ModalDevHistory({
    Key key,
    this.colormodal,
    this.colorbuttom,
    this.histList,
  }) : super(key: key);

  @override
  _ModalDevHistoryState createState() => _ModalDevHistoryState();
}

class _ModalDevHistoryState extends State<ModalDevHistory> {
  final formKey = GlobalKey<FormState>();
  String date, symptom;
  bool tcVisibility = false;
  // VaccineList modelVac;
  HistoryDev modelHist;
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
          Icon(Icons.warning_rounded, color: nav),
          SizedBox(
            width: 13,
          ),
          Text(modelHist.symptom == null
              ? "ไม่มีอาการผิดปกติ"
              : modelHist.symptom)
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
          Icon(Icons.calendar_today_rounded, color: nav),
          SizedBox(
            width: 13,
          ),
          Center(
            child: Text(modelHist.day),
          ),
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
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      modelHist.name,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    datebox(),
                    SizedBox(
                      height: 11,
                    ),
                    symptombox(),
                    SizedBox(
                      width: 30,
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
