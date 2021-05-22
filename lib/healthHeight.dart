import 'dart:async';
import 'package:BabyBeamApp/components/button_back_pages.dart';
import 'package:BabyBeamApp/components/datePicker.dart';
import 'package:BabyBeamApp/components/photo.dart';
import 'package:BabyBeamApp/components/rounded_input_field.dart';
import 'package:BabyBeamApp/components/small_rounded_button.dart';
import 'package:BabyBeamApp/components/text_field_container.dart';
import 'package:BabyBeamApp/health.dart';
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/healthStandard.dart';
import 'package:BabyBeamApp/model/historyHealth.dart';
import 'package:BabyBeamApp/model/user.dart';
import 'package:BabyBeamApp/myStyle.dart';
import 'package:BabyBeamApp/predict/polynomialRegression.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'heightHistory.dart';

class HealthHeight extends StatefulWidget {
  @override
  _HealthHeightState createState() => _HealthHeightState();
}

class _HealthHeightState extends State<HealthHeight> {
  String valueHeight, dateHeight;
  List<double> valuePolynomialRegression = [];
  static Map<String, dynamic> mapValue = Map();
  static Map<String, dynamic> mapSD = Map();
  static Map<String, dynamic> mapRegressions = Map();

  bool err = false;

  @override
  void initState() {
    super.initState();
  }

  Future getHistory(String valueHeight, int ageYInput) async {
    String userID = Account.userID;

    // Add Value
    mapValue[(BabyInfo.ageY - ageYInput).toString()] = valueHeight;
    FirebaseFirestore.instance
        .collection('/baby_profile/$userID/health_record')
        .doc('height')
        .set(mapValue, SetOptions(merge: true));

    // Predict for SD
    if (ageYInput == 0) {
      mapSD[BabyInfo.ageY.toString()] = valueHeight;
      double SD = HealthStandard.medianHeightList[BabyInfo.ageY] -
          double.parse(valueHeight);
      for (int i = BabyInfo.ageY + 1; i <= BabyInfo.ageY + 5; i++)
        mapSD['$i'] = (HealthStandard.medianHeightList[i] - SD).toString();

      // Add SD
      FirebaseFirestore.instance
          .collection('/baby_profile/$userID/health_record')
          .doc('heightSD')
          .set(mapSD, SetOptions(merge: true));

      // Add Regressions
      valuePolynomialRegression = [];
      valuePolynomialRegression = HistoryHealth.valuePolynomialRegressionHeight;
      valuePolynomialRegression[BabyInfo.ageY - ageYInput] =
          double.parse(valueHeight);
      for (int i = BabyInfo.ageY + 1; i <= 19; i++)
        valuePolynomialRegression.add(HealthStandard.medianHeightList[i] - SD);
    } else {
      // Add Regressions
      valuePolynomialRegression = [];
      valuePolynomialRegression = HistoryHealth.valuePolynomialRegressionHeight;
      valuePolynomialRegression[BabyInfo.ageY - ageYInput] =
          double.parse(valueHeight);
      double SD = HealthStandard.medianHeightList[BabyInfo.ageY] -
          HistoryHealth.valuePolynomialRegressionHeight[
              HistoryHealth.valuePolynomialRegressionHeight.length - 1];
      for (int i = BabyInfo.ageY + 1; i <= 19; i++)
        valuePolynomialRegression.add(HealthStandard.medianHeightList[i] - SD);
    }

    // Predict for Regressions
    print(valuePolynomialRegression);
    List p = calculatePolynomialRegression(valuePolynomialRegression, [
      BabyInfo.ageY + 1,
      BabyInfo.ageY + 2,
      BabyInfo.ageY + 3,
      BabyInfo.ageY + 4,
      BabyInfo.ageY + 5
    ]);
    int k = 0;
    mapRegressions[BabyInfo.ageY.toString()] =
        valuePolynomialRegression[BabyInfo.ageY].toString();
    for (int i = BabyInfo.ageY + 1; i <= BabyInfo.ageY + 5; i++) {
      mapRegressions['$i'] = (p[k]).toString();
      k++;
    }

    // Add valuePolynomialRegression
    FirebaseFirestore.instance
        .collection('/baby_profile/$userID/health_record')
        .doc('heightRegressions')
        .set(mapRegressions, SetOptions(merge: true));

    HistoryHealth().readHistory('height', BabyInfo.ageY);

    await delay(200);

    return Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => HealthHeight()));
  }

  Future<Null> delay(int milliseconds) {
    return new Future.delayed(new Duration(milliseconds: milliseconds));
  }

  Future<void> insertValue() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['date'] = PickerState.date_picker;
    map['height'] = valueHeight;
    map['time'] = PickerState.date_picker2;

    await firebaseFirestore
        .collection('baby_profile/${user.uid}/height_history')
        .doc()
        .set(map)
        .then((value) {
      print('Insert Success');
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ButtonBackPages(
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Health();
                          },
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      'ส่วนสูง',
                      style: TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Photo(),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HeightHistory()));
                        },
                        child: Icon(
                          Icons.bookmark_rounded,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                        color: greenBackGroundColor,
                      ),
                    ),
                  ),
                ],
              ),
              TextFieldContainer(
                color: Colors.white,
                width: 1.0,
                child: Container(
                  height: size.height * 0.45,
                  width: size.width,
                  child: LineChart.withData(),
                ),
              ),
              TextFieldContainer(
                color: Colors.white,
                width: 1.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RoundedInputField(
                      iconColor: cadetBlueCrayola,
                      hintText: 'ส่วนสูง (เซนติเมตร)',
                      keyboardType: TextInputType.number,
                      input: valueHeight==null?null:valueHeight,
                      onChanged: (value) {
                        valueHeight = value.trim();
                      },
                    ),
                    TextFieldContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today_rounded,
                            color: cadetBlueCrayola,
                          ),
                          Text(
                            'วันที่',
                            style: TextStyle(fontFamily: 'Medium'),
                          ),
                          Picker(
                            backgroundcolor: Colors.white,
                            fontColor: Colors.black,
                            width: 177,
                            showText: 'เลือกวันที่',
                          ),
                        ],
                      ),
                    ),
                    err == true
                        ? Text(
                            'กรุณาตรวจสอบข้อมูลอีกครั้ง',
                            style: TextStyle(color: redbeam),
                          )
                        : Text(''),
                    SmallRoundedButton(
                      text: 'เพิ่ม',
                      font: 'Medium',
                      textColor: Colors.white,
                      color: cadetBlueCrayola,
                      press: () {
                        dateHeight = PickerState.date_picker;
                        if (valueHeight != null &&
                            dateHeight != null &&
                            double.parse(valueHeight) > 0 &&
                            double.parse(valueHeight) < 200) {
                          print('value Height = $valueHeight');
                          print('value ageY = ${PickerState.ageY}');
                          getHistory(valueHeight, PickerState.ageY);
                          insertValue();
                          HistoryHealth().getBMI(double.parse(valueHeight),
                              BabyInfo.ageY - PickerState.ageY, 'Height',PickerState.date_picker2,dateHeight);
                        } else {
                          err = true;
                          print('No value Height');
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example of a stacked area chart.
class LineChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  LineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory LineChart.withData() {
    // print('read Data to Chart');
    return new LineChart(
      _createData(),
      animate: true,
    );
  }

  @override
  _LineChartState createState() => _LineChartState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearData, int>> _createData() {
    return [
      new charts.Series<LinearData, int>(
        id: 'ค่าเฉลี่ย',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HealthStandard.medianHeight,
      ),
      new charts.Series<LinearData, int>(
        id: 'น้อยกว่าเกณฑ์',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HealthStandard.underThresholdHeight,
      ),
      new charts.Series<LinearData, int>(
        id: 'มากกว่าเกณฑ์',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HealthStandard.overThresholdHeight,
      ),
      new charts.Series<LinearData, int>(
        id: 'ส่วนสูง',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HistoryHealth.valueHeight == null
            ? [
                new LinearData(0, null),
              ]
            : HistoryHealth.valueHeight,
      ),
      new charts.Series<LinearData, int>(
        id: 'Predict',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        dashPatternFn: (_, __) => [2, 2],
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HistoryHealth.sdValueHeight == null
            ? [
                new LinearData(0, null),
              ]
            : HistoryHealth.sdValueHeight,
      ),
      new charts.Series<LinearData, int>(
        id: 'Regressions',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        dashPatternFn: (_, __) => [4, 4],
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HistoryHealth.regressionsValueHeight == null
            ? [
                new LinearData(0, null),
              ]
            : HistoryHealth.regressionsValueHeight,
      ),
    ];
  }
}

class _LineChartState extends State<LineChart> {
  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      widget.seriesList,
      defaultRenderer: new charts.LineRendererConfig(),
      animate: widget.animate,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(zeroBound: false)),
      behaviors: [
        new charts.ChartTitle(
          'ปี',
          behaviorPosition: charts.BehaviorPosition.bottom,
        ),
        new charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 3,
          showMeasures: true,
        ),
      ],
    );
  }
}

// class LinearData {
//   final int year;
//   final double data;

//   LinearData(this.year, this.data);
// }
