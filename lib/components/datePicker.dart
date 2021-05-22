import 'package:age/age.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class Picker extends StatefulWidget {
  final Color backgroundcolor, fontColor;
  final double width, height;
  final String showText,input;

  const Picker(
      {Key key,
      this.backgroundcolor,
      this.fontColor,
      this.width,
      this.height,
      this.showText = "เลือกวันที่",
      this.input,
      })
      : super(key: key);

  @override
  PickerState createState() => PickerState();
}

class PickerState extends State<Picker> {
  static int ageY, ageM, ageD = 0;
  String birthDate;
  DateTime dateNote;
  String age = 'ปี - เดือน - วัน';
  static bool confirm = false;
  static String date_picker; 
  static DateTime date_picker2 ;

   @override
  void initState(){
    super.initState();
    date_picker = null;
    birthDate = widget.showText;
  }

  void changeDate(DateTime date) {
    setState(() {
      AgeDuration age2 =
          Age.dateDifference(fromDate: date, toDate: DateTime.now());
      ageY = age2.years;
      ageM = age2.months;
      ageD = age2.days;
      age = '${ageY}ปี ${ageM}เดือน ${ageD}วัน';
      print(age);
      birthDate = new DateFormat('dd MMM y').format(date).toString();
      date_picker2 = date;
      print('lll : $date_picker2');
      date_picker = birthDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: widget.backgroundcolor,
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              // minTime: DateFormat("dd MMM y").parse(BabyInfo.birthDay),
              minTime:  DateTime(2000, 1, 1),
              maxTime: DateTime.now(), onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            changeDate(date);
            confirm = true;
            dateNote = date;
          },
              currentTime: dateNote == null ? DateTime.now() : dateNote,
              locale: LocaleType.th);
        },
        child: Text(
          birthDate,
          style: TextStyle(
            color: widget.fontColor,
          ),
        ),
      ),
    );
  }
}
