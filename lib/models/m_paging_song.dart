// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kpop_lyrics/models/m_song.dart';

class SongPaging {
  int? page;
  List<MSong> records = [];
  int? totalPage;
  int? nextPage;
  SongPaging({
    this.page,
    required this.records,
    this.totalPage,
    this.nextPage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'records': records.map((x) => x.toMap()).toList(),
      'totalPage': totalPage,
      'nextPage': nextPage,
    };
  }

  factory SongPaging.fromMap(Map<String, dynamic> map) {
    return SongPaging(
      page: map['page'] != null ? map['page'] as int : null,
      records: List<MSong>.from(
        (map['records'] ?? []).map<MSong>(
          (x) => MSong.fromMap(x),
        ),
      ),
      totalPage: map['totalPage'] != null ? map['totalPage'] as int : null,
      nextPage: map['nextPage'] != null ? map['nextPage'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SongPaging.fromJson(String source) =>
      SongPaging.fromMap(json.decode(source) as Map<String, dynamic>);
}
