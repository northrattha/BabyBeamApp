import 'dart:convert';
class ModelVac02 {
  final String s;
  final String e;
  ModelVac02({
    this.s,
    this.e,
    
  });

  ModelVac02 copyWith({
    String s,
    String e,
  }) {
    return ModelVac02(
      s: s ?? this.s,
      e: e ?? this.e,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      's': s,
      'e': e,
    };
  }

  factory ModelVac02.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ModelVac02(
      s: map['s'],
      e: map['e'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelVac02.fromJson(String source) => ModelVac02.fromMap(json.decode(source));

  @override
  String toString() => 'ModelVac02(s: $s, e: $e)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ModelVac02 &&
      o.s == s &&
      o.e == e;
  }

  @override
  int get hashCode => s.hashCode ^ e.hashCode;
}
