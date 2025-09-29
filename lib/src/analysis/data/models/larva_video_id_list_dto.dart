// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LarvaVideoIdListDto {
  final int count;
  final String? next;
  final String? previous;
  final List<dynamic> results;
  LarvaVideoIdListDto({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'next': next,
      'previous': previous,
      'results': results,
    };
  }

  factory LarvaVideoIdListDto.fromMap(Map<String, dynamic> map) {
    return LarvaVideoIdListDto(
      count: map['count'] as int,
      next: map['next'] != null ? map['next'] as String : null,
      previous: map['previous'] != null ? map['previous'] as String : null,
      results: List<dynamic>.from((map['results'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory LarvaVideoIdListDto.fromJson(String source) =>
      LarvaVideoIdListDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
