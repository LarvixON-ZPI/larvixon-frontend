import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/larva_video_status.dart';

typedef LarvaVideoResults = List<(String, double)>;

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

  Map<String, dynamic> toJson() {
    return {
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
}
