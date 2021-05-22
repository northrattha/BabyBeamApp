import 'dart:convert';

class GraphSympHist {
  final int number;
  final String symp;
  GraphSympHist({
    this.number,
    this.symp,
  });


  GraphSympHist copyWith({
    int number,
    String symp,
  }) {
    return GraphSympHist(
      number: number ?? this.number,
      symp: symp ?? this.symp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'symp': symp,
    };
  }

  factory GraphSympHist.fromMap(Map<String, dynamic> map) {
    return GraphSympHist(
      number: map['number'],
      symp: map['symp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GraphSympHist.fromJson(String source) => GraphSympHist.fromMap(json.decode(source));

  @override
  String toString() => 'GraphSympHist(number: $number, symp: $symp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GraphSympHist &&
      other.number == number &&
      other.symp == symp;
  }

  @override
  int get hashCode => number.hashCode ^ symp.hashCode;
}
