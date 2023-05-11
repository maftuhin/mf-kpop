// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:kpop_lyrics/models/m_track.dart';

class SoundtrackPaging {
  List<MTrack> records = [];
  int? page;
  int? totalPage;
  int? nextPage;
  SoundtrackPaging({
    required this.records,
    this.page,
    this.totalPage,
    this.nextPage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'records': records.map((x) => x.toMap()).toList(),
      'page': page,
      'totalPage': totalPage,
      'nextPage': nextPage,
    };
  }

  factory SoundtrackPaging.fromMap(Map<String, dynamic> map) {
    return SoundtrackPaging(
      records: List<MTrack>.from(
        (map['records'] ?? []).map<MTrack>(
          (x) => MTrack.fromMap(x as Map<String, dynamic>),
        ),
      ),
      page: map['page'] != null ? map['page'] as int : null,
      totalPage: map['totalPage'] != null ? map['totalPage'] as int : null,
      nextPage: map['nextPage'] != null ? map['nextPage'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SoundtrackPaging.fromJson(String source) =>
      SoundtrackPaging.fromMap(json.decode(source) as Map<String, dynamic>);
}
