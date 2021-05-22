import 'dart:convert';

class HeadCirCum {
  final String headCirCum;
  final String date;
  HeadCirCum({
    this.headCirCum,
    this.date,
  });

  HeadCirCum copyWith({
    String headCirCum,
    String date,
  }) {
    return HeadCirCum(
      headCirCum: headCirCum ?? this.headCirCum,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'headCirCum': headCirCum,
      'date': date,
    };
  }

  factory HeadCirCum.fromMap(Map<String, dynamic> map) {
    return HeadCirCum(
      headCirCum: map['headCirCum'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HeadCirCum.fromJson(String source) =>
      HeadCirCum.fromMap(json.decode(source));

  @override
  String toString() => 'HeadCirCum(headCirCum: $headCirCum, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HeadCirCum &&
        other.headCirCum == headCirCum &&
        other.date == date;
  }

  @override
  int get hashCode => headCirCum.hashCode ^ date.hashCode;
}
