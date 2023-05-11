// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MArtist {
  int? id;
  String? code; 
  String? name;
  MArtist({
    this.id,
    this.code,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
    };
  }

  factory MArtist.fromMap(Map<String, dynamic> map) {
    return MArtist(
      id: map['id'] != null ? map['id'] as int : null,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MArtist.fromJson(String source) => MArtist.fromMap(json.decode(source) as Map<String, dynamic>);
}
