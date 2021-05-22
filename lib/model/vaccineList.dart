import 'dart:convert';

class VaccineList {
  final String name;
  final String key;
  final String id;
  final String note;
  VaccineList({
    this.name,
    this.key,
    this.id,
    this.note,
  });
  

  VaccineList copyWith({
    String name,
    String key,
    String id,
    String note,
  }) {
    return VaccineList(
      name: name ?? this.name,
      key: key ?? this.key,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'key': key,
      'id': id,
      'note': note,
    };
  }

  factory VaccineList.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return VaccineList(
      name: map['name'],
      key: map['key'],
      id: map['id'],
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VaccineList.fromJson(String source) => VaccineList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VaccineList(name: $name, key: $key, id: $id, note: $note)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is VaccineList &&
      o.name == name &&
      o.key == key &&
      o.id == id &&
      o.note == note;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      key.hashCode ^
      id.hashCode ^
      note.hashCode;
  }
}
