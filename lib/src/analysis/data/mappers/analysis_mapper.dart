import 'package:larvixon_frontend/src/analysis/data/models/analysis_dto.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';
import 'package:larvixon_frontend/src/common/utils/base_mapper.dart';
import 'package:larvixon_frontend/src/patient/data/mappers/patient_mapper.dart';
import 'package:larvixon_frontend/src/patient/domain/entities/patient.dart';

class AnalysisMapper implements Mapper<AnalysisDTO, Analysis> {
  final PatientMapper _patientMapper = PatientMapper();
  @override
  Analysis dtoToEntity(AnalysisDTO dto) {
    Patient? patient;
    if (dto.patient_details != null) {
      try {
        patient = _patientMapper.dtoToEntity(dto.patient_details!);
      } catch (e) {
        patient = null;
      }
    }

    return Analysis(
      id: dto.id,
      uploadedAt: DateTime.parse(dto.created_at),
      status: AnalysisProgressStatus.fromString(dto.status),
      description: dto.description,
      analysedAt: dto.completed_at != null
          ? DateTime.parse(dto.completed_at!)
          : null,
      thumbnailUrl: dto.thumbnailUrl,
      results: dto.confidence_scores != null
          ? AnalysisResultsMapper.fromMap(dto.confidence_scores!)
          : null,
      patient: patient,
    );
  }

  @override
  AnalysisDTO entityToDto(Analysis entity) {
    // TODO: implement entityToDto
    throw UnimplementedError();
  }
}
