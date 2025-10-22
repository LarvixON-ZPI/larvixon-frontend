import 'dart:math';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_id_list.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_upload_response.dart';
import 'package:larvixon_frontend/src/analysis/domain/failures/failures.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';

class AnalysisRepositoryRepository implements AnalysisRepository {
  final Random _random = Random();
  final List<String> _substances = [
    "Ethanol",
    "Caffeine",
    "Nicotine",
    "THC",
    "LSD",
    "No Substance",
    "Cocaine",
    "Methamphetamine",
    "Heroin",
    "MDMA",
    "Amphetamine",
    "Morphine",
    "Ketamine",
  ];
  final List<Analysis> _videos = [
    Analysis(id: 1, uploadedAt: DateTime.now(), name: "zebrafish experiment 1"),
    Analysis(
      id: 2,
      uploadedAt: DateTime.now(),
      name: "zebrafish experiment 2",
      thumbnailUrl:
          "https://www.shutterstock.com/shutterstock/videos/32685646/thumb/1.jpg?ip=x480",
    ),
    Analysis(id: 3, uploadedAt: DateTime.now(), name: "danio rerio study"),
    Analysis(id: 4, uploadedAt: DateTime.now(), name: "larva lsd test"),
    Analysis(
      id: 5,
      uploadedAt: DateTime.now(),
      name: "fish larvae alcohol test",
    ),
    Analysis(
      id: 6,
      uploadedAt: DateTime.now(),
      name: "fish larvae caffeine test",
      status: AnalysisProgressStatus.completed,
      results: const [("Caffeine", 0.87), ("Ethanol", 0.12)],
      analysedAt: DateTime.now(),
      thumbnailUrl:
          "https://media.springernature.com/lw685/springer-static/image/chp%3A10.1007%2F978-1-4939-8940-9_13/MediaObjects/448871_1_En_13_Fig1_HTML.jpg",
    ),
    Analysis(
      id: 7,
      uploadedAt: DateTime.now(),
      name: "fish larvae nicotine test",
    ),
    Analysis(id: 8, uploadedAt: DateTime.now(), name: "fish larvae THC test"),
  ];

  @override
  TaskEither<Failure, AnalysisIdList> fetchVideoIds({
    String? nextPage,
    AnalysisSort? sort,
  }) {
    return TaskEither.tryCatch(() async {
      await Future.delayed(const Duration(seconds: 1));

      final sortedVideos = List<Analysis>.from(_videos);

      if (sort != null) {
        sortedVideos.sort((a, b) {
          final comparison = _compareByField(a, b, sort.field);
          return sort.order == SortOrder.ascending ? comparison : -comparison;
        });
      } else {
        sortedVideos.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
      }

      return AnalysisIdList(
        ids: sortedVideos.map((video) => video.id).toList(),
      );
    }, (error, _) => UnknownAnalysisFailure(message: error.toString()));
  }

  @override
  TaskEither<Failure, Analysis> fetchVideoDetailsById(int id) {
    final Random random = Random();
    return TaskEither.tryCatch(
      () async {
        await Future.delayed(Duration(milliseconds: random.nextInt(250)));
        return _videos.firstWhere((video) => video.id == id);
      },
      (error, _) {
        return UnknownAnalysisFailure(message: error.toString());
      },
    );
  }

  @override
  Future<List<Analysis>> fetchVideosDetails() {
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, Analysis>> watchVideoProgressById({
    required int id,
    Duration interval = const Duration(seconds: 5),
  }) async* {
    final Random random = Random();
    while (true) {
      final video = await fetchVideoDetailsById(id).run();
      if (video.isLeft()) {
        yield video;
        break;
      }
      var v = video.getRight().toNullable()!;

      if (v.status == AnalysisProgressStatus.completed ||
          v.status == AnalysisProgressStatus.failed) {
        if (v.status == AnalysisProgressStatus.completed && v.results == null) {
          v = _applyRandomSubstances(v);
          final index = _videos.indexWhere((v) => v.id == id);
          _videos[index] = v;
        }
        yield Either.right(v);
        break;
      }
      yield Either.right(v);

      var updatedVideo = v;

      if (random.nextDouble() < 0.02) {
        updatedVideo = updatedVideo.copyWith(
          status: AnalysisProgressStatus.failed,
        );
      } else {
        updatedVideo = updatedVideo.copyWith(
          status: updatedVideo.status.progressStatus(),
        );
      }

      if (updatedVideo.status == AnalysisProgressStatus.completed) {
        updatedVideo = _applyRandomSubstances(updatedVideo);
        updatedVideo = updatedVideo.copyWith(analysedAt: DateTime.now());
      }
      final index = _videos.indexWhere((v) => v.id == id);
      _videos[index] = updatedVideo;
      await Future.delayed(interval);
    }
  }

  Analysis _applyRandomSubstances(Analysis video) {
    final int substanceCount = _random.nextInt(_substances.length) + 1;
    final sub = (_substances.toList()..shuffle()).take(substanceCount);
    final results = [for (var s in sub) (s, _random.nextDouble())]
      ..sort((a, b) => b.$2.compareTo(a.$2));
    return video.copyWith(results: results);
  }

  @override
  TaskEither<AnalysisFailure, AnalysisUploadResponse> uploadVideo({
    required Uint8List bytes,
    required String filename,
    required String title,
  }) {
    return TaskEither.tryCatch(
      () async {
        await Future.delayed(const Duration(milliseconds: 250));
        final nextId =
            (_videos.isEmpty ? 0 : _videos.map((e) => e.id).reduce(max)) + 1;
        _videos.insert(
          0,
          Analysis(id: nextId, uploadedAt: DateTime.now(), name: title),
        );
        return AnalysisUploadResponse(
          id: nextId,
          message: 'Video uploaded successfully',
        );
      },
      (error, _) {
        return UploadFailure(message: error.toString());
      },
    );
  }

  int _compareByField(Analysis a, Analysis b, AnalysisSortField field) {
    return switch (field) {
      AnalysisSortField.title => _compareNullableStrings(a.name, b.name),
      AnalysisSortField.createdAt => a.uploadedAt.compareTo(b.uploadedAt),
    };
  }

  int _compareNullableStrings(String? a, String? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }
}
