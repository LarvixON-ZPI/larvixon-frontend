import 'package:larvixon_frontend/src/analysis/data/models/analysis_dto.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';
import 'package:larvixon_frontend/src/common/base_mapper.dart';

class AnalysisMapper implements Mapper<AnalysisDTO, Analysis> {
  @override
  Analysis dtoToEntity(AnalysisDTO dto) {
    return Analysis(
      id: dto.id,
      uploadedAt: DateTime.parse(dto.created_at),
      status: AnalysisProgressStatus.fromString(dto.status),
      name: dto.title ?? 'Unnamed',
      analysedAt: dto.completed_at != null
          ? DateTime.parse(dto.completed_at!)
          : null,
      thumbnailUrl: dto.thumbnailUrl,
      results: dto.confidence_scores != null
          ? AnalysisResultsMapper.fromMap(dto.confidence_scores!)
          : null,
    );
  }

  @override
  AnalysisDTO entityToDto(Analysis entity) {
    // TODO: implement entityToDto
    throw UnimplementedError();
  }
}

// Map<String, dynamic> toMap() {
//   return <String, dynamic>{
//     'id': id,
//     'uploaded_at': uploadedAt.toIso8601String(),
//     'status': status.name,
//     'error_message': errorMessage,
//     'name': name,
//     'analysed_at': analysedAt?.toIso8601String(),
//     'results': results
//         ?.map((e) => {'substance': e.$1, 'concentration': e.$2})
//         .toList(),
//     'thumbnail_url': thumbnailUrl,
//   };
// }

// factory LarvaVideo.fromJson(Map<String, dynamic> map) {
//   return LarvaVideo(
//     id: map['id'] as int,
//     uploadedAt: DateTime.parse(map['created_at'] as String),
//     status: LarvaVideoStatus.fromString(map['status']),
//     errorMessage: map['errorMessage'] != null
//         ? map['errorMessage'] as String
//         : null,
//     name: map['name'] != null ? map['name'] as String : 'Unnamed',
//     analysedAt: map['completed_at'] != null
//         ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int)
//         : null,
//     thumbnailUrl: map['thumbnailUrl'] != null
//         ? map['thumbnailUrl'] as String
//         : null,
//     results: map['confidence_scores'] != null
//         ? LarvaVideoResultsX.fromMap(
//             map['confidence_scores'] as List<dynamic>,
//           )
//         : null,
//   );
// }
