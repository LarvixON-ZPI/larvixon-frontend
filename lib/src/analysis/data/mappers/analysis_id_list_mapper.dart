import 'package:larvixon_frontend/src/analysis/data/models/analysis_id_list_dto.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_id_list.dart';
import 'package:larvixon_frontend/src/common/base_mapper.dart';

class AnalysisIdListMapper
    implements Mapper<AnalysisIdListDTO, AnalysisIdList> {
  @override
  AnalysisIdList dtoToEntity(AnalysisIdListDTO dto) {
    final results = <int>[];
    for (var e in dto.results) {
      if (e is Map<String, dynamic> && e['id'] is int) {
        results.add(e['id'] as int);
      }
    }
    return AnalysisIdList(ids: results, nextPage: dto.next);
  }

  @override
  AnalysisIdListDTO entityToDto(AnalysisIdList entity) {
    // TODO: implement entityToDto
    throw UnimplementedError();
  }
}
