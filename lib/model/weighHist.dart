import 'dart:convert';

class WeighHist {
   final String weigh;
  final String date;
  WeighHist({
     this.weigh,
     this.date,
  });

  WeighHist copyWith({
    String weigh,
    String date,
  }) {
    return WeighHist(
      weigh: weigh ?? this.weigh,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weigh': weigh,
      'date': date,
    };
  }

  factory WeighHist.fromMap(Map<String, dynamic> map) {
    return WeighHist(
      weigh: map['weigh'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WeighHist.fromJson(String source) => WeighHist.fromMap(json.decode(source));

  @override
  String toString() => 'WeighHist(weigh: $weigh, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is WeighHist &&
      other.weigh == weigh &&
      other.date == date;
  }

  @override
  int get hashCode => weigh.hashCode ^ date.hashCode;
}
