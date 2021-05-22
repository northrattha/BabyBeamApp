import 'dart:convert';

class HeightHist {
  final String height;
  final String date;
  HeightHist({
    this.height,
   this.date,
  });
 

  HeightHist copyWith({
    String height,
    String date,
  }) {
    return HeightHist(
      height: height ?? this.height,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'date': date,
    };
  }

  factory HeightHist.fromMap(Map<String, dynamic> map) {
    return HeightHist(
      height: map['height'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HeightHist.fromJson(String source) => HeightHist.fromMap(json.decode(source));

  @override
  String toString() => 'HeightHist(height: $height, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HeightHist &&
      other.height == height &&
      other.date == date;
  }

  @override
  int get hashCode => height.hashCode ^ date.hashCode;
}
