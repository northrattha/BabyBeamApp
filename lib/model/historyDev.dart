import 'dart:convert';

class HistoryDev {
  final String name;
  final String key;
  final String day;
  final String id;
  final String symptom;
  HistoryDev({
    this.name,
    this.key,
    this.day,
    this.id,
    this.symptom,
  });

  HistoryDev copyWith({
    String name,
    String key,
    String day,
    String id,
    String symptom,
  }) {
    return HistoryDev(
      name: name ?? this.name,
      key: key ?? this.key,
      day: day ?? this.day,
      id: id ?? this.id,
      symptom: symptom ?? this.symptom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'key': key,
      'day': day,
      'id': id,
      'symptom': symptom,
    };
  }

  factory HistoryDev.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return HistoryDev(
      name: map['name'],
      key: map['key'],
      day: map['day'],
      id: map['id'],
      symptom: map['symptom'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryDev.fromJson(String source) => HistoryDev.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HistoryDev(name: $name, key: $key, day: $day, id: $id, symptom: $symptom)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is HistoryDev &&
      o.name == name &&
      o.key == key &&
      o.day == day &&
      o.id == id &&
      o.symptom == symptom;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      key.hashCode ^
      day.hashCode ^
      id.hashCode ^
      symptom.hashCode;
  }
}
