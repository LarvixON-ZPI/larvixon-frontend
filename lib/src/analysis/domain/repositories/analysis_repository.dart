import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_filter.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_id_list.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_upload_response.dart';

import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';

abstract class AnalysisRepository {
  TaskEither<Failure, AnalysisIdList> fetchVideoIds({
    String? nextPage,
    AnalysisSort? sort,
    AnalysisFilter? filter,
  });
  TaskEither<Failure, Analysis> fetchVideoDetailsById(int id);
  Future<List<Analysis>> fetchVideosDetails();
  Stream<Either<Failure, Analysis>> watchVideoProgressById({
    required int id,
    Duration interval = const Duration(seconds: 5),
  });
  TaskEither<Failure, AnalysisUploadResponse> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  });
}
