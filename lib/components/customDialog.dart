import 'package:age/age.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../myStyle.dart';

class customDialog extends StatefulWidget {
  final String title, content,birthDate;
  final Color backgroundcolor;


  customDialog(
      {Key key,
      this.title,
      this.content,
      this.backgroundcolor = Colors.black38, this.birthDate='เลือกวันที่'})
      : super(key: key);

  @override
  _customDialogState createState() => _customDialogState();
}

class _customDialogState extends State<customDialog> {
  int ageY, ageM, ageD = 0;
  String birthDate = 'เลือกวันเกิด';
  DateTime dateNote;
  String age = 'ปี - เดือน - วัน';
  // var birthDate = widget;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: dialogContent(context),
      // child: Text('data'),
      backgroundColor: Colors.transparent,
    );
  }

  dialogContent(BuildContext context) {
    return Stack(children: [
      Container(
        width: 500,
        height: MediaQuery.of(context).size.height / 2.5,
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.only(top: 80, bottom: 0, left: 16, right: 16),
        decoration: BoxDecoration(
          color: white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(widget.title),
            SizedBox(
              height: 5,
            ),
            Text(widget.content),
            SizedBox(
              height: 10,
            ),
            datePicker(),
          ],
        ),
      ),
      Positioned(
        top: 0,
        left: 16,
        right: 16,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: widget.backgroundcolor,
          // backgroundImage: Image(image: ''),
        ),
      ),
    ]);
  }

  Widget field() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'สถานที่ :',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        enabledBorder: new UnderlineInputBorder(
            // borderSide: BorderSide(color: Colors.white),
            ),
        focusedBorder: new UnderlineInputBorder(
            // borderSide: BorderSide(color: Colors.white),
            ),
      ),
      onSaved: (String value) {
        // firstName = value.trim();
      },
    );
  }

  Widget select() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
              child: Text('วันที่ :'),
              width: 75,
            ),
            datePicker(),
          ],
        ),
        line(1.0),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget datePicker() {
    return Container(
      width: 190,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: widget.backgroundcolor,
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(1990, 1, 1),
              maxTime: DateTime.now(), onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            changeDate(date);
            print('confirm $date');
            dateNote = date;
            // print('object $dateNote');
            // print('object ${DateTime.now()}');
            // }, currentTime: DateTime.now(), locale: LocaleType.th);
          },
              currentTime: dateNote == null ? DateTime.now() : dateNote,
              locale: LocaleType.th);
        },
        child: Text(
          birthDate,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
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
    });
  }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 0,
//       child: dialogContent(context),
//       backgroundColor: Colors.transparent,
//     );
//   }

//   Widget dialogContent(BuildContext context) {
//     return Stack(children: [
//       Container(
//         width: 500,
//         height: MediaQuery.of(context).size.height / 2.5,
//         margin: EdgeInsets.only(top: 50),
//         padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
//         decoration: BoxDecoration(
//           color: white,
//           shape: BoxShape.rectangle,
//           borderRadius: BorderRadius.all(
//             Radius.circular(16),
//           ),
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: white
//           //     ,offset: Offset(0.0,1.1)
//           //   )
//           // ]
//         ),
//         child: Column(
//           children: <Widget>[
//             Text(title),
//             Text(content),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'ชื่อ :',
//                 labelStyle:
//                     TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                 enabledBorder: new UnderlineInputBorder(
//                   // borderSide: BorderSide(color: Colors.white),
//                 ),
//                 focusedBorder: new UnderlineInputBorder(
//                   // borderSide: BorderSide(color: Colors.white),
//                 ),
//               ),
//               onSaved: (String value) {
//                 // firstName = value.trim();
//               },
//             ),
//           ],
//         ),
//       ),
//       Positioned(
//           top: 0,
//           left: 16,
//           right: 16,
//           child: CircleAvatar(
//             radius: 50,
//             backgroundColor: Colors.black,
//           ))
//     ]);
//   }
// }
}
