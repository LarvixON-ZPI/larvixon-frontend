import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/data/datasources/larva_video_datasource.dart';
import 'package:larvixon_frontend/src/analysis/data/mappers/larva_video_id_list_mapper.dart';
import 'package:larvixon_frontend/src/analysis/data/mappers/larva_video_mapper.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/larva_video.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/larva_video_id_list.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/larva_video_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/video_upload_response.dart';
import 'package:larvixon_frontend/src/analysis/domain/failures/failures.dart';

import 'larva_video_repository.dart';

class LarvaVideoRepositoryImpl implements LarvaVideoRepository {
  final LarvaVideoDatasource dataSource;
  final LarvaVideoMapper videoMapper = LarvaVideoMapper();
  final LarvaVideoIdListMapper idListMapper = LarvaVideoIdListMapper();

  LarvaVideoRepositoryImpl({required this.dataSource});
  @override
  TaskEither<VideoFailure, VideoUploadResponse> uploadVideo({
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
      return VideoUploadResponse.fromJson(data);
    }, (error, stackTrace) => UploadFailure(message: error.toString()));
  }

  @override
  TaskEither<VideoFailure, LarvaVideo> fetchVideoDetailsById(int id) {
    return TaskEither.tryCatch(() {
      return dataSource.fetchVideoDetailsById(id).then((data) {
        return videoMapper.dtoToEntity(data);
      });
    }, (error, stackTrace) => UnknownVideoFailure(message: error.toString()));
  }

  @override
  TaskEither<Failure, LarvaVideoIdList> fetchVideoIds({String? nextPage}) {
    return TaskEither.tryCatch(
      () async {
        final results = await dataSource.fetchVideosIds(nextPage: nextPage);
        final entity = idListMapper.dtoToEntity(results);
        return entity;
      },
      (error, stackTrace) {
        return UnknownVideoFailure(message: error.toString());
      },
    );
  }

  @override
  Future<List<LarvaVideo>> fetchVideosDetails() {
    // TODO: implement fetchVideosDetails
    throw UnimplementedError();
  }

  @override
  Stream<Either<VideoFailure, LarvaVideo>> watchVideoProgressById({
    required int id,
    Duration interval = const Duration(seconds: 5),
  }) async* {
    while (true) {
      final result = await fetchVideoDetailsById(id).run();
      yield result;

      if (result.isRight()) {
        final video = result.getRight().toNullable();
        if (video?.status == LarvaVideoStatus.completed ||
            video?.status == LarvaVideoStatus.failed) {
          break;
        }
      }

      await Future.delayed(interval);
    }
  }
}
