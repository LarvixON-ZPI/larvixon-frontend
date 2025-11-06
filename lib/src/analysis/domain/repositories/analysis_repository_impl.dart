import 'dart:async';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/data/datasources/analysis_datasource.dart';
import 'package:larvixon_frontend/src/analysis/data/mappers/analysis_id_list_mapper.dart';
import 'package:larvixon_frontend/src/analysis/data/mappers/analysis_mapper.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_filter.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_id_list.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_upload_response.dart';
import 'package:larvixon_frontend/src/analysis/domain/failures/failures.dart';

import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisDatasource dataSource;
  final AnalysisMapper videoMapper = AnalysisMapper();
  final AnalysisIdListMapper idListMapper = AnalysisIdListMapper();
  final StreamController<AnalysisIdList> _analysisIdsController =
      StreamController.broadcast();
  final List<int> _cachedIds = [];
  String? _nextPage;
  bool _hasMore = true;

  AnalysisRepositoryImpl({required this.dataSource});
  @override
  TaskEither<AnalysisFailure, AnalysisUploadResponse> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
    void Function(double progress)? onProgress,
  }) {
    return TaskEither.tryCatch(() async {
      final data = await dataSource.uploadVideo(
        bytes: bytes,
        filename: filename,
        title: title,
        onProgress: (sent, total) {
          if (total > 0) onProgress?.call(sent / total);
        },
      );
      final response = AnalysisUploadResponse.fromJson(data);
      _cachedIds.insert(0, response.id);
      _emitUpdatedList();
      return response;
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
  TaskEither<Failure, AnalysisIdList> fetchVideoIds({
    String? nextPage,
    AnalysisSort? sort,
    AnalysisFilter? filter,
  }) {
    return TaskEither.tryCatch(
      () async {
        final results = await dataSource.fetchAnalysisIds(
          nextPage: nextPage,
          sort: sort,
          filter: filter,
        );
        final entity = idListMapper.dtoToEntity(results);
        if (nextPage != null) {
          _cachedIds.addAll(entity.ids.where((id) => !_cachedIds.contains(id)));
        } else {
          _cachedIds
            ..clear()
            ..addAll(entity.ids);
        }

        _nextPage = entity.nextPage;
        _hasMore = entity.hasMore;

        _emitUpdatedList();

        return AnalysisIdList(
          ids: List.unmodifiable(_cachedIds),
          nextPage: _nextPage,
        );
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

  @override
  TaskEither<Failure, bool> deleteAnalysis({required int id}) {
    return TaskEither.tryCatch(
      () async {
        final bool deleted = await dataSource.deleteAnalysis(id: id);
        if (deleted) {
          _cachedIds.remove(id);
          _emitUpdatedList();
        }
        return deleted;
      },
      (error, stackStrace) {
        return UnknownFailure(message: error.toString());
      },
    );
  }

  @override
  Stream<AnalysisIdList> get analysisIdsStream => _analysisIdsController.stream;

  @override
  void dispose() {
    _analysisIdsController.close();
  }

  void _emitUpdatedList() {
    final entity = AnalysisIdList(
      ids: List.unmodifiable(_cachedIds),
      nextPage: _nextPage,
    );
    _analysisIdsController.add(entity);
  }
}
