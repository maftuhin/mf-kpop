// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MTrack {
  String? title;
  String? uid;
  String? image;
  MTrack({
    this.title,
    this.uid,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'uid': uid,
      'image': image,
    };
  }

  factory MTrack.fromMap(Map<String, dynamic> map) {
    return MTrack(
      title: map['title'] != null ? map['title'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MTrack.fromJson(String source) => MTrack.fromMap(json.decode(source) as Map<String, dynamic>);
}
