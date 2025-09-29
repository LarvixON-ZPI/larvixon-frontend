import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/data/larva_video_datasource.dart';
import 'package:larvixon_frontend/src/analysis/domain/failures.dart';
import 'package:larvixon_frontend/src/analysis/domain/video_upload_response.dart';
import 'package:larvixon_frontend/src/analysis/larva_video.dart';
import 'package:larvixon_frontend/src/analysis/larva_video_status.dart';

import 'larva_video_repository.dart';

class LarvaVideoRepositoryImpl implements LarvaVideoRepository {
  final LarvaVideoDatasource dataSource;

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
        return LarvaVideo.fromJson(data);
      });
    }, (error, stackTrace) => UnknownVideoFailure(message: error.toString()));
  }

  @override
  TaskEither<Failure, VideoFetchIdsResponse> fetchVideoIds({String? nextPage}) {
    return TaskEither.tryCatch(
      () async {
        final results = await dataSource.fetchVideosIds(nextPage: nextPage);
        final idsJson = results['results'];
        if (idsJson is List) {
          final ids = <int>[];
          for (final e in idsJson) {
            if (e is Map<String, dynamic> && e['id'] is int) {
              ids.add(e['id'] as int);
            } else {}
          }
          String? nextPage = results['next'];
          return (ids, nextPage);
        }
        return (<int>[], null);
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
