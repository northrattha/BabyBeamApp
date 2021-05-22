import 'package:BabyBeamApp/model/historyHealth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthStandard {
  static var median;
  static var underThreshold;
  static var overThreshold;

  static List<double> medianList = [];

  // Wgight
  static var medianWeight;
  static var underThresholdWeight;
  static var overThresholdWeight;
  // Height
  static var medianHeight;
  static var underThresholdHeight;
  static var overThresholdHeight;
  // Head Circumference
  static var medianHeadCircumference;
  static var underThresholdHeadCircumference;
  static var overThresholdHeadCircumference;
  // BMI
  static var medianBMI;
  static var underThresholdBMI;
  static var overThresholdBMI;

  // Weight
  static List<double> medianWeightList;
  // Height
  static List<double> medianHeightList;
  // Head Circumference
  static List<double> medianHeadCircumferenceList;
  // BMI
  static List<double> medianBMIList;

  Future readStandard(String readData, int age, String sex) async {
    String sexData = sex == 'หญิง' ? 'Women' : 'Men';

    FirebaseFirestore.instance
        .collection('/Health')
        .doc(readData)
        .snapshots()
        .listen((event) async {
      median = [
        new LinearData(0, double.parse(event.data()['median$sexData'][0])),
      ];
      underThreshold = [
        new LinearData(
            0, double.parse(event.data()['underThreshold$sexData'][0])),
      ];
      overThreshold = [
        new LinearData(
            0, double.parse(event.data()['overThreshold$sexData'][0])),
      ];
      for (int i = 1; i <= age + 5; i++) {
        if (i > 5 && readData == 'Head_Circumference')
          break;
        else if (i > 10 && readData == 'Weight')
          break;
        else if (i > 19 && (readData == 'Height' || readData == 'BMI')) break;

        median += [
          new LinearData(i, double.parse(event.data()['median$sexData'][i])),
        ];
        underThreshold += [
          new LinearData(
              i, double.parse(event.data()['underThreshold$sexData'][i])),
        ];
        overThreshold += [
          new LinearData(
              i, double.parse(event.data()['overThreshold$sexData'][i])),
        ];
      }

      switch (readData) {
        case 'Weight':
          medianWeight = median;
          underThresholdWeight = underThreshold;
          overThresholdWeight = overThreshold;
          break;
        case 'Height':
          medianHeight = median;
          underThresholdHeight = underThreshold;
          overThresholdHeight = overThreshold;
          break;
        case 'Head_Circumference':
          medianHeadCircumference = median;
          underThresholdHeadCircumference = underThreshold;
          overThresholdHeadCircumference = overThreshold;
          break;
        case 'BMI':
          medianBMI = median;
          underThresholdBMI = underThreshold;
          overThresholdBMI = overThreshold;
          break;
      }
      // print('read ' + readData);
    });
  }

  Future readMedianListStandard(String readData, String sex) async {
    String sexData = sex == 'หญิง' ? 'Women' : 'Men';

    FirebaseFirestore.instance
        .collection('/Health')
        .doc(readData)
        .snapshots()
        .listen((event) {
      medianList = [];
      for (int i = 0; i < event.data()['median$sexData'].length; i++)
        medianList.add(double.parse(event.data()['median$sexData'][i]));

      switch (readData) {
        case 'Weight':
          medianWeightList = medianList;
          break;
        case 'Height':
          medianHeightList = medianList;
          break;
        case 'Head_Circumference':
          medianHeadCircumferenceList = medianList;
          break;
        case 'BMI':
          medianBMIList = medianList;
          break;
      }
    });
  }
}
