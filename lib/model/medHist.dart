import 'dart:convert';

class MedHist {
  final String day;
  final String title;
  final String detail;
  MedHist({
    this.day,
    this.title,
    this.detail,
  });

  MedHist copyWith({
    String day,
    String title,
    String detail,
  }) {
    return MedHist(
      day: day ?? this.day,
      title: title ?? this.title,
      detail: detail ?? this.detail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'title': title,
      'detail': detail,
    };
  }

  factory MedHist.fromMap(Map<String, dynamic> map) {
    return MedHist(
      day: map['day'],
      title: map['title'],
      detail: map['detail'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MedHist.fromJson(String source) => MedHist.fromMap(json.decode(source));

  @override
  String toString() => 'MedHist(day: $day, title: $title, detail: $detail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MedHist &&
      other.day == day &&
      other.title == title &&
      other.detail == detail;
  }

  @override
  int get hashCode => day.hashCode ^ title.hashCode ^ detail.hashCode;
}
