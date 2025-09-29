import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/larva_video_id_list.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/video_upload_response.dart';

import '../entities/larva_video.dart';

typedef VideoFetchIdsResponse = (List<int> ids, String? nextPage);

abstract class LarvaVideoRepository {
  TaskEither<Failure, LarvaVideoIdList> fetchVideoIds({String? nextPage});
  TaskEither<Failure, LarvaVideo> fetchVideoDetailsById(int id);
  Future<List<LarvaVideo>> fetchVideosDetails();
  Stream<Either<Failure, LarvaVideo>> watchVideoProgressById({
    required int id,
    Duration interval = const Duration(seconds: 5),
  });
  TaskEither<Failure, VideoUploadResponse> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  });
}
