import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';

import '../larva_video.dart';

abstract class LarvaVideoRepository {
  Future<List<int>> fetchVideoIds();
  TaskEither<Failure, LarvaVideo> fetchVideoDetailsById(int id);
  Future<List<LarvaVideo>> fetchVideosDetails();
  Stream<Either<Failure, LarvaVideo>> watchVideoProgressById({
    required int id,
    Duration interval = const Duration(seconds: 5),
  });
  TaskEither<Failure, void> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  });
}
