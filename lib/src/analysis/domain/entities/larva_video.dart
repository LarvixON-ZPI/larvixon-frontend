// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/larva_video_status.dart';

typedef LarvaVideoResults = List<(String, double)>;

extension LarvaVideoResultsX on LarvaVideoResults {
  static LarvaVideoResults fromMap(List<dynamic> list) {
    final results = list.map((e) {
      if (e is! List<dynamic> || e.length != 2) {
        throw FormatException('Invalid substance entry: $e');
      }
      final [substance as String, concentration as double] = e;

      return (substance, concentration);
    }).toList();

    return results;
  }
}

class LarvaVideo extends Equatable {
  final int id;
  final DateTime uploadedAt;
  final LarvaVideoStatus status;
  final String? errorMessage;
  final String name;
  final DateTime? analysedAt;
  final String? thumbnailUrl;
  final LarvaVideoResults? results;

  const LarvaVideo({
    required this.id,
    required this.uploadedAt,
    required this.name,
    this.status = LarvaVideoStatus.pending,
    this.analysedAt,
    this.thumbnailUrl,
    this.results,

    this.errorMessage,
  });

  LarvaVideo copyWith({
    int? id,
    DateTime? uploadedAt,
    LarvaVideoStatus? status,
    double? progress,
    String? errorMessage,
    String? name,
    DateTime? analysedAt,
    LarvaVideoResults? results,
    String? thumbnailUrl,
  }) {
    return LarvaVideo(
      id: id ?? this.id,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
      analysedAt: analysedAt ?? this.analysedAt,
      results: results ?? this.results,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    uploadedAt,
    status,
    errorMessage,
    name,
    analysedAt,
    results,
    thumbnailUrl,
  ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uploaded_at': uploadedAt.toIso8601String(),
      'status': status.name,
      'error_message': errorMessage,
      'name': name,
      'analysed_at': analysedAt?.toIso8601String(),
      'results': results
          ?.map((e) => {'substance': e.$1, 'concentration': e.$2})
          .toList(),
      'thumbnail_url': thumbnailUrl,
    };
  }

  factory LarvaVideo.fromJson(Map<String, dynamic> map) {
    return LarvaVideo(
      id: map['id'] as int,
      uploadedAt: DateTime.parse(map['created_at'] as String),
      status: LarvaVideoStatus.fromString(map['status']),
      errorMessage: map['errorMessage'] != null
          ? map['errorMessage'] as String
          : null,
      name: map['name'] != null ? map['name'] as String : 'Unnamed',
      analysedAt: map['completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int)
          : null,
      thumbnailUrl: map['thumbnailUrl'] != null
          ? map['thumbnailUrl'] as String
          : null,
      results: map['confidence_scores'] != null
          ? LarvaVideoResultsX.fromMap(
              map['confidence_scores'] as List<dynamic>,
            )
          : null,
    );
  }
}
