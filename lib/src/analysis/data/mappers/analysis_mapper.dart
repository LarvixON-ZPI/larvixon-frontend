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
