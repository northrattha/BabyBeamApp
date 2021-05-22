import 'dart:convert';

class Develop {
  final String name;
  final String key;
  final String id;
  Develop({
    this.name,
    this.key,
    this.id,
  });
  

  Develop copyWith({
    String name,
    String key,
    String id,
  }) {
    return Develop(
      name: name ?? this.name,
      key: key ?? this.key,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'key': key,
      'id': id,
    };
  }

  factory Develop.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Develop(
      name: map['name'],
      key: map['key'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Develop.fromJson(String source) => Develop.fromMap(json.decode(source));

  @override
  String toString() => 'Develop(name: $name, key: $key, id: $id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Develop &&
      o.name == name &&
      o.key == key &&
      o.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ key.hashCode ^ id.hashCode;
}
