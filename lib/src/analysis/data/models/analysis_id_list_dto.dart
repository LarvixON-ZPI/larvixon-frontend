// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AnalysisIdListDTO {
  final int count;
  final String? next;
  final String? previous;
  final List<dynamic> results;
  AnalysisIdListDTO({
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

  factory AnalysisIdListDTO.fromMap(Map<String, dynamic> map) {
    return AnalysisIdListDTO(
      count: map['count'] as int,
      next: map['next'] as String?,
      previous: map['previous'] as String?,
      results: List<dynamic>.from((map['results'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalysisIdListDTO.fromJson(String source) =>
      AnalysisIdListDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
