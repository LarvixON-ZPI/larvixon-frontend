import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/src/analysis/data/larva_video_datasource.dart';
import 'package:larvixon_frontend/src/analysis/domain/failures.dart';
import 'package:larvixon_frontend/src/analysis/larva_video.dart';

import 'larva_video_repository.dart';

class LarvaVideoRepositoryImpl implements LarvaVideoRepository {
  final LarvaVideoDatasource dataSource;

  LarvaVideoRepositoryImpl({required this.dataSource});
  @override
  TaskEither<VideoFailure, void> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  }) {
    return TaskEither.tryCatch(
      () async {
        await dataSource.uploadVideo(
          bytes: bytes,
          filename: filename,
          title: title,
        );
      },
      (error, stackTrace) =>
          UploadFailure(message: 'Failed to upload video: $error'),
    );
  }

  @override
  TaskEither<VideoFailure, LarvaVideo> fetchVideoDetailsById(int id) {
    return TaskEither.left(UnknownVideoFailure(message: 'Not implemented yet'));
  }

  @override
  Future<List<int>> fetchVideoIds() {
    // TODO: implement fetchVideoIds
    throw UnimplementedError();
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
    yield Either.left(UnknownVideoFailure(message: 'Not implemented yet'));
  }
}
