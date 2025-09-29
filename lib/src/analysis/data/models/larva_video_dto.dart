// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class LarvaVideoDto {
  final int id;
  final String video_name;
  final String status;
  final String created_at;
  final String? completed_at;
  final List<dynamic>? confidence_scores;
  final String? user_feedback;
  final String? thumbnailUrl;
  final String? title;

  const LarvaVideoDto({
    required this.id,
    required this.video_name,
    required this.status,
    required this.created_at,
    this.completed_at,
    this.confidence_scores,
    this.user_feedback,
    this.thumbnailUrl,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'video_name': video_name,
      'status': status,
      'created_at': created_at,
      'completed_at': completed_at,
      'confidence_scores': confidence_scores,
      'user_feedback': user_feedback,
      'thumbnail_url': thumbnailUrl,
      'title': title,
    };
  }

  factory LarvaVideoDto.fromMap(Map<String, dynamic> map) {
    return LarvaVideoDto(
      id: map['id'] as int,
      video_name: map['video_name'] as String,
      status: map['status'] as String,
      created_at: map['created_at'] as String,
      completed_at: map['completed_at'] != null
          ? map['completed_at'] as String
          : null,
      confidence_scores: map['confidence_scores'] != null
          ? map['confidence_scores'] as List<dynamic>
          : null,
      user_feedback: map['user_feedback'] != null
          ? map['user_feedback'] as String
          : null,
      thumbnailUrl: map['thumbnail_url'] != null
          ? map['thumbnail_url'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LarvaVideoDto.fromJson(String source) =>
      LarvaVideoDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
