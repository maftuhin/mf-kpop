// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kpop_lyrics/models/m_artist.dart';

class PagingArtist {
  int? page;
  List<MArtist> records = [];
  int? totalPage;
  int? nextPage;
  PagingArtist({
    this.page,
    required this.records,
    this.totalPage,
    this.nextPage,
  });

  bool isLastPage() {
    return totalPage == page;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'records': records.map((x) => x.toMap()).toList(),
      'totalPage': totalPage,
      'nextPage': nextPage,
    };
  }

  factory PagingArtist.fromMap(Map<String, dynamic> map) {
    return PagingArtist(
      page: map['page'] != null ? map['page'] as int : null,
      records: List<MArtist>.from(
        (map['records'] ?? []).map<MArtist>(
          (x) => MArtist.fromMap(x),
        ),
      ),
      totalPage: map['totalPage'] != null ? map['totalPage'] as int : null,
      nextPage: map['nextPage'] != null ? map['nextPage'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PagingArtist.fromJson(String source) =>
      PagingArtist.fromMap(json.decode(source) as Map<String, dynamic>);
}
