
import 'package:BabyBeamApp/model/babyInfo.dart';
import 'package:BabyBeamApp/model/healthStandard.dart';
import 'package:BabyBeamApp/model/user.dart';
import 'package:BabyBeamApp/predict/polynomialRegression.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryHealth {
  static var value;
  static var sdValue;
  static var regressionsValue;

  // Weight
  static var valueWeight;
  static var sdValueWeight;
  static var regressionsValueWeight;
  // Height
  static var valueHeight;
  static var sdValueHeight;
  static var regressionsValueHeight;
  // Head Circumference
  static var valueHeadCircumference;
  static var sdValueHeadCircumference;
  static var regressionsValueHeadCircumference;
  // BMI
  static var valueBMI;
  static var sdValueBMI;
  static var regressionsValueBMI;

  static List<double> valuePolynomialRegression;
  // Weight
  static List<double> valuePolynomialRegressionWeight;
  // Height
  static List<double> valuePolynomialRegressionHeight;
  // Head Circumference
  static List<double> valuePolynomialRegressionHeadCircumference;
  // BMI
  static List<double> valuePolynomialRegressionBMI;

  // get BMI
  static Map<String, dynamic> mapValue = Map();
  static Map<String, dynamic> mapSD = Map();
  static Map<String, dynamic> mapRegressions = Map();

  Future readHistory(String readData, int age) async {
    String userID = Account.userID;

    FirebaseFirestore.instance
        .collection('/baby_profile/$userID/health_record')
        .doc(readData)
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        int numList = 0;
        value = [];
        valuePolynomialRegression = [];
        for (; numList <= age; numList++) {
          if (event.data()['$numList'] != null) {
            value = [
              new LinearData(numList, double.parse(event.data()['$numList'])),
            ];

            //Add valuePolynomialRegression
            valuePolynomialRegression
                .add(double.parse(event.data()['$numList']));

            numList++;
            break;
          } else {
            //Add valuePolynomialRegression
            valuePolynomialRegression.add(null);
          }
        }

        for (; numList <= age; numList++) {
          if (event.data()['$numList'] != null) {
            value += [
              new LinearData(numList, double.parse(event.data()['$numList'])),
            ];
            //Add valuePolynomialRegression
            valuePolynomialRegression
                .add(double.parse(event.data()['$numList']));
          } else {
            valuePolynomialRegression.add(null);
          }
        }

        switch (readData) {
          case 'weight':
            // print(readData + value.toString());
            valueWeight = value;
            valuePolynomialRegressionWeight = valuePolynomialRegression;
            break;
          case 'height':
            // print(readData + value.toString());
            valueHeight = value;
            valuePolynomialRegressionHeight = valuePolynomialRegression;
            break;
          case 'headCircumference':
            // print(readData + value.toString());
            valueHeadCircumference = value;
            valuePolynomialRegressionHeadCircumference =
                valuePolynomialRegression;
            break;
          case 'bmi':
            // print(readData + value.toString());
            valueBMI = value;
            valuePolynomialRegressionBMI = valuePolynomialRegression;
            break;
        }
      }
    });

    FirebaseFirestore.instance
        .collection('/baby_profile/$userID/health_record')
        .doc('$readData' + 'SD')
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        sdValue = [];
        sdValue = [
          new LinearData(age, double.parse(event.data()['$age'])),
        ];

        for (int numList = age + 1; numList <= age + 5; numList++) {
          if (event.data()['$numList'] != null) {
            sdValue += [
              new LinearData(numList, double.parse(event.data()['$numList'])),
            ];
          }
        }
        switch (readData) {
          case 'weight':
            // print(readData + sdValue.toString());
            sdValueWeight = sdValue;
            break;
          case 'height':
            // print(readData + sdValue.toString());
            sdValueHeight = sdValue;
            break;
          case 'headCircumference':
            // print(readData + sdValue.toString());
            sdValueHeadCircumference = sdValue;
            break;
          case 'bmi':
            // print(readData + sdValue.toString());
            sdValueBMI = sdValue;
            break;
        }
      }
    });

    FirebaseFirestore.instance
        .collection('/baby_profile/$userID/health_record')
        .doc('$readData' + 'Regressions')
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        regressionsValue = [];
        regressionsValue = [
          new LinearData(age, double.parse(event.data()['$age'])),
        ];

        for (int numList = age + 1; numList <= age + 5; numList++) {
          if (event.data()['$numList'] != null) {
            regressionsValue += [
              new LinearData(numList, double.parse(event.data()['$numList'])),
            ];
          }
        }
        switch (readData) {
          case 'weight':
            // print(readData + regressionsValue.toString());
            regressionsValueWeight = regressionsValue;
            break;
          case 'height':
            // print(readData + regressionsValue.toString());
            regressionsValueHeight = regressionsValue;
            break;
          case 'headCircumference':
            // print(readData + regressionsValue.toString());
            regressionsValueHeadCircumference = regressionsValue;
            break;
          case 'bmi':
            // print(readData + regressionsValue.toString());
            regressionsValueBMI = regressionsValue;
            break;
        }
      }
    });

    // print('read History');
  }

    Future<void> insertValue(double valueBMI,DateTime dateTime,String date) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> map = Map();
    map['date'] = date;
    map['weigh'] = valueBMI;
    map['time'] = dateTime;

    await firebaseFirestore
        .collection('baby_profile/${user.uid}/bmi_history')
        .doc()
        .set(map)
        .then((value) {
      print('Insert Success');
    });
  }

  // BMI = Weight/(Height^2)
  Future getBMI(double value, int ageYInput, String typeValue, DateTime dateTime,String date) async {
    String userID = Account.userID;
    String type = typeValue == 'Weight' ? 'height' : 'weight';
    double valueRead,valueBMI;

    FirebaseFirestore.instance
        .collection('/baby_profile/$userID/health_record')
        .doc(type)
        .snapshots()
        .listen((event) {
      valueRead = double.parse(event.data()['$ageYInput']);

      if (valueRead != null) {
        if (typeValue == 'Height') {
          // value is Height
          valueBMI = valueRead / ((value / 100) * (value / 100));
          mapValue[ageYInput.toString()] = valueBMI.toString();
          insertValue(valueBMI,dateTime,date);

        } else {
          // value is Weight
          valueBMI = value / ((valueRead / 100) * (valueRead / 100));
          mapValue[ageYInput.toString()] = valueBMI.toString();
        }
      }

      // Add Value
      FirebaseFirestore.instance
          .collection('/baby_profile/$userID/health_record')
          .doc('bmi')
          .set(mapValue, SetOptions(merge: true));
    });

    await delay(300);

    // Predict for SD
    if (ageYInput == BabyInfo.ageY) {
      mapSD[BabyInfo.ageY.toString()] = valueBMI.toString();
      double SD = HealthStandard.medianBMIList[BabyInfo.ageY] - valueBMI;
      for (int i = BabyInfo.ageY + 1; i <= BabyInfo.ageY + 5; i++)
        mapSD['$i'] = (HealthStandard.medianBMIList[i] - SD).toString();

      // Add SD
      FirebaseFirestore.instance
          .collection('/baby_profile/$userID/health_record')
          .doc('bmiSD')
          .set(mapSD, SetOptions(merge: true));

      print(mapSD);

      // Add Regressions
      valuePolynomialRegression = [];
      valuePolynomialRegression = HistoryHealth.valuePolynomialRegressionBMI;
      valuePolynomialRegression[ageYInput] = valueBMI;
      for (int i = BabyInfo.ageY + 1; i <= 19; i++)
        valuePolynomialRegression.add(HealthStandard.medianBMIList[i] - SD);
    } else {
      // Add Regressions
      valuePolynomialRegression = [];
      valuePolynomialRegression = HistoryHealth.valuePolynomialRegressionBMI;
      valuePolynomialRegression[ageYInput] = valueBMI;
      double SD = HealthStandard.medianBMIList[BabyInfo.ageY] -
          HistoryHealth.valuePolynomialRegressionBMI[
              HistoryHealth.valuePolynomialRegressionBMI.length - 1];
      for (int i = BabyInfo.ageY + 1; i <= 19; i++)
        valuePolynomialRegression.add(HealthStandard.medianBMIList[i] - SD);
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
        .doc('bmiRegressions')
        .set(mapRegressions, SetOptions(merge: true));

    HistoryHealth().readHistory('bmi', BabyInfo.ageY);

    await delay(200);
  }

  Future<Null> delay(int milliseconds) {
    return new Future.delayed(new Duration(milliseconds: milliseconds));
  }
}

class LinearData {
  final int year;
  final double data;

  LinearData(this.year, this.data);
}
