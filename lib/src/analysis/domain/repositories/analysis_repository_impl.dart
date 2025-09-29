import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/data/datasources/analysis_datasource.dart';
import 'package:larvixon_frontend/src/analysis/data/mappers/analysis_id_list_mapper.dart';
import 'package:larvixon_frontend/src/analysis/data/mappers/analysis_mapper.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_id_list.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_upload_response.dart';
import 'package:larvixon_frontend/src/analysis/domain/failures/failures.dart';

import 'analysis_repository.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisDatasource dataSource;
  final AnalysisMapper videoMapper = AnalysisMapper();
  final AnalysisIdListMapper idListMapper = AnalysisIdListMapper();

  AnalysisRepositoryImpl({required this.dataSource});
  @override
  TaskEither<AnalysisFailure, AnalysisUploadResponse> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  }) {
    return TaskEither.tryCatch(() async {
      final data = await dataSource.uploadVideo(
        bytes: bytes,
        filename: filename,
        title: title,
      );
      return AnalysisUploadResponse.fromJson(data);
    }, (error, stackTrace) => UploadFailure(message: error.toString()));
  }

  @override
  TaskEither<AnalysisFailure, Analysis> fetchVideoDetailsById(int id) {
    return TaskEither.tryCatch(
      () {
        return dataSource.fetchAnalysisDetailsById(id).then((dto) {
          return videoMapper.dtoToEntity(dto);
        });
      },
      (error, stackTrace) => UnknownAnalysisFailure(message: error.toString()),
    );
  }

  @override
  TaskEither<Failure, AnalysisIdList> fetchVideoIds({String? nextPage}) {
    return TaskEither.tryCatch(
      () async {
        final results = await dataSource.fetchAnalysisIds(nextPage: nextPage);
        final entity = idListMapper.dtoToEntity(results);
        return entity;
      },
      (error, stackTrace) {
        return UnknownAnalysisFailure(message: error.toString());
      },
    );
  }

  @override
  Future<List<Analysis>> fetchVideosDetails() {
    // TODO: implement fetchVideosDetails
    throw UnimplementedError();
  }

  @override
  Stream<Either<AnalysisFailure, Analysis>> watchVideoProgressById({
    required int id,
    Duration interval = const Duration(seconds: 5),
  }) async* {
    while (true) {
      final result = await fetchVideoDetailsById(id).run();
      yield result;

      if (result.isRight()) {
        final video = result.getRight().toNullable();
        if (video?.status == AnalysisProgressStatus.completed ||
            video?.status == AnalysisProgressStatus.failed) {
          break;
        }
      }

      await Future.delayed(interval);
    }
  }
}
