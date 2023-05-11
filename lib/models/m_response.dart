import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApiResponse {
  String? message;
  ApiResponse({
    this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponse.fromJson(String source) => ApiResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
