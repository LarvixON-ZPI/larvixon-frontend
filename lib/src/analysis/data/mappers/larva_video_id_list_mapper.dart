import 'package:larvixon_frontend/src/analysis/data/models/larva_video_id_list_dto.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/larva_video_id_list.dart';
import 'package:larvixon_frontend/src/common/base_mapper.dart';

class LarvaVideoIdListMapper
    implements Mapper<LarvaVideoIdListDto, LarvaVideoIdList> {
  @override
  LarvaVideoIdList dtoToEntity(LarvaVideoIdListDto dto) {
    final results = <int>[];
    for (var e in dto.results) {
      if (e is Map<String, dynamic> && e['id'] is int) {
        results.add(e['id'] as int);
      }
    }
    return LarvaVideoIdList(ids: results, nextPage: dto.next);
  }

  @override
  LarvaVideoIdListDto entityToDto(LarvaVideoIdList entity) {
    // TODO: implement entityToDto
    throw UnimplementedError();
  }
}
