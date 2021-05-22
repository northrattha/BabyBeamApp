import 'package:BabyBeamApp/components/button_back_pages.dart';
import 'package:BabyBeamApp/components/photo.dart';
import 'package:BabyBeamApp/components/text_field_container.dart';
import 'package:BabyBeamApp/health.dart';
import 'package:BabyBeamApp/model/healthStandard.dart';
import 'package:BabyBeamApp/model/historyHealth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HealthBMI extends StatefulWidget {
  @override
  _HealthBMIState createState() => _HealthBMIState();
}

class _HealthBMIState extends State<HealthBMI> {
  String valueBMI, dateBMI;
  List<double> valuePolynomialRegression = [];
  static Map<String, dynamic> mapValue = Map();
  static Map<String, dynamic> mapSD = Map();
  static Map<String, dynamic> mapRegressions = Map();

  // bool err = false;

  @override
  void initState() {
    super.initState();
  }

  // Future getHistory(String valueBMI, int ageYInput) async {
  //   String userID = UserClass.userID;

  //   // Add Value
  //   mapValue[(BabyInfo.ageY - ageYInput).toString()] = valueBMI;
  //   FirebaseFirestore.instance
  //       .collection('/baby_profile/$userID/health_record')
  //       .doc('bmi')
  //       .set(mapValue, SetOptions(merge: true));

  //   // Predict for SD
  //   if (ageYInput == 0) {
  //     mapSD[BabyInfo.ageY.toString()] = valueBMI;
  //     double SD =
  //         HealthStandard.medianBMIList[BabyInfo.ageY] - double.parse(valueBMI);
  //     for (int i = BabyInfo.ageY + 1; i <= BabyInfo.ageY + 5; i++)
  //       mapSD['$i'] = (HealthStandard.medianBMIList[i] - SD).toString();

  //     // Add SD
  //     FirebaseFirestore.instance
  //         .collection('/baby_profile/$userID/health_record')
  //         .doc('bmiSD')
  //         .set(mapSD, SetOptions(merge: true));

  //     // Add Regressions
  //     valuePolynomialRegression = [];
  //     valuePolynomialRegression = HistoryHealth.valuePolynomialRegression;
  //     valuePolynomialRegression[BabyInfo.ageY - ageYInput] =
  //         double.parse(valueBMI);
  //     for (int i = BabyInfo.ageY + 1; i <= 19; i++)
  //       valuePolynomialRegression.add(HealthStandard.medianBMIList[i] - SD);
  //   } else {
  //     // Add Regressions
  //     valuePolynomialRegression = [];
  //     valuePolynomialRegression = HistoryHealth.valuePolynomialRegression;
  //     valuePolynomialRegression[BabyInfo.ageY - ageYInput] =
  //         double.parse(valueBMI);
  //     double SD = HealthStandard.medianBMIList[BabyInfo.ageY] -
  //         HistoryHealth.valuePolynomialRegression[
  //             HistoryHealth.valuePolynomialRegression.length - 1];
  //     for (int i = BabyInfo.ageY + 1; i <= 19; i++)
  //       valuePolynomialRegression.add(HealthStandard.medianBMIList[i] - SD);
  //   }

  //   // Predict for Regressions
  //   print(valuePolynomialRegression);
  //   List p = calculatePolynomialRegression(valuePolynomialRegression, [
  //     BabyInfo.ageY + 1,
  //     BabyInfo.ageY + 2,
  //     BabyInfo.ageY + 3,
  //     BabyInfo.ageY + 4,
  //     BabyInfo.ageY + 5
  //   ]);
  //   int k = 0;
  //   mapRegressions[BabyInfo.ageY.toString()] =
  //       valuePolynomialRegression[BabyInfo.ageY].toString();
  //   for (int i = BabyInfo.ageY + 1; i <= BabyInfo.ageY + 5; i++) {
  //     mapRegressions['$i'] = (p[k]).toString();
  //     k++;
  //   }

  //   // Add valuePolynomialRegression
  //   FirebaseFirestore.instance
  //       .collection('/baby_profile/$userID/health_record')
  //       .doc('bmiRegressions')
  //       .set(mapRegressions, SetOptions(merge: true));

  //   HistoryHealth().readHistory('bmi', BabyInfo.ageY);

  //   await delay(200);

  //   return Navigator.of(context)
  //       .push(new MaterialPageRoute(builder: (context) => HealthBMI()));
  // }

  // Future<Null> delay(int milliseconds) {
  //   return new Future.delayed(new Duration(milliseconds: milliseconds));
  // }

 
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                        'ดัชนีมวลกาย',
                        style: TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 24,
                        ),
                      ),
                  Photo(),
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
              // TextFieldContainer(
              //   color: Colors.white,
              //   width: 1.0,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       RoundedInputField(
              //         iconColor: cadetBlueCrayola,
              //         hintText: 'ดัชนีมวลกาย (เซนติเมตร)',
              //         keyboardType: TextInputType.number,
              //         onChanged: (value) {
              //           valueBMI = value.trim();
              //         },
              //       ),
              //       TextFieldContainer(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             Icon(
              //               Icons.calendar_today_rounded,
              //               color: cadetBlueCrayola,
              //             ),
              //             Text(
              //               'วันที่',
              //               style: TextStyle(fontFamily: 'Medium'),
              //             ),
              //             Picker(
              //               backgroundcolor: Colors.white,
              //               fontColor: Colors.black,
              //               width: 177,
              //               showText: 'เลือกวันที่',
              //             ),
              //           ],
              //         ),
              //       ),
              //       err == true
              //           ? Text(
              //               'กรุณาตรวจสอบข้อมูลอีกครั้ง',
              //               style: TextStyle(color: redbeam),
              //             )
              //           : Text(''),
              //       SmallRoundedButton(
              //         text: 'เพิ่ม',
              //         font: 'Medium',
              //         textColor: Colors.white,
              //         color: cadetBlueCrayola,
              //         press: () {
              //           dateBMI = PickerState.date_picker;
              //           if (valueBMI != null &&
              //               dateBMI != null &&
              //               double.parse(valueBMI) > 0 &&
              //               double.parse(valueBMI) < 200) {
              //             print('value BMI = $valueBMI');
              //             print('value ageY = ${PickerState.ageY}');
              //             getHistory(valueBMI, PickerState.ageY);
              //           } else {
              //             err = true;
              //             print('No value BMI');
              //             setState(() {});
              //           }
              //         },
              //       ),
              //     ],
              //   ),
              // ),
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
        data: HealthStandard.medianBMI,
      ),
      new charts.Series<LinearData, int>(
        id: 'น้อยกว่าเกณฑ์',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HealthStandard.underThresholdBMI,
      ),
      new charts.Series<LinearData, int>(
        id: 'มากกว่าเกณฑ์',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HealthStandard.overThresholdBMI,
      ),
      new charts.Series<LinearData, int>(
        id: 'ดัชนีมวลกาย',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HistoryHealth.valueBMI == null
            ? [
                new LinearData(0, null),
              ]
            : HistoryHealth.valueBMI,
      ),
      new charts.Series<LinearData, int>(
        id: 'Predict',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        dashPatternFn: (_, __) => [2, 2],
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HistoryHealth.sdValueBMI == null
            ? [
                new LinearData(0, null),
              ]
            : HistoryHealth.sdValueBMI,
      ),
      new charts.Series<LinearData, int>(
        id: 'Regressions',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        dashPatternFn: (_, __) => [4, 4],
        domainFn: (LinearData data, _) => data.year,
        measureFn: (LinearData data, _) => data.data,
        data: HistoryHealth.regressionsValueBMI == null
            ? [
                new LinearData(0, null),
              ]
            : HistoryHealth.regressionsValueBMI,
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
