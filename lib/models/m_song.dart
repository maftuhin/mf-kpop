import 'dart:convert';

import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class MSong {
  int? id;
  String? uid;
  String? title;
  String? artist;
  String? language;
  String? lyric;
  int? view;
  MSong({
    this.id,
    this.uid,
    this.title,
    this.artist,
    this.language,
    this.lyric,
    this.view,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'artist': artist,
      'language': language,
      'lyric': lyric,
      'view': view,
    };
  }

  factory MSong.fromMap(Map<String, dynamic> map) {
    return MSong(
      id: map['id'] != null ? map['id'] as int : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      language: map['language'] != null ? map['language'] as String : null,
      lyric: map['lyric'] != null ? map['lyric'] as String : null,
      view: map['view'] != null ? map['view'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MSong.fromJson(String source) => MSong.fromMap(json.decode(source) as Map<String, dynamic>);
}
