import 'dart:convert';

class BMI {
  final String bmi;
  final String date;
  BMI({
     this.bmi,
     this.date,
  });

  BMI copyWith({
    String bmi,
    String date,
  }) {
    return BMI(
      bmi: bmi ?? this.bmi,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bmi': bmi,
      'date': date,
    };
  }

  factory BMI.fromMap(Map<String, dynamic> map) {
    return BMI(
      bmi: map['bmi'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BMI.fromJson(String source) => BMI.fromMap(json.decode(source));

  @override
  String toString() => 'BMI(bmi: $bmi, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BMI &&
      other.bmi == bmi &&
      other.date == date;
  }

  @override
  int get hashCode => bmi.hashCode ^ date.hashCode;
}
