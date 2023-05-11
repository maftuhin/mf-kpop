import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DataMessage {
  String? message;
  String? name;
  DataMessage({
    this.message,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'name': name,
    };
  }

  factory DataMessage.fromMap(Map<String, dynamic> map) {
    return DataMessage(
      message: map['message'] != null ? map['message'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataMessage.fromJson(String source) => DataMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}
