import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_field_enum.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_filter.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_id_list.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_upload_response.dart';
import 'package:larvixon_frontend/src/analysis/domain/failures/failures.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';

class AnalysisRepositoryFake implements AnalysisRepository {
  int nextPage = 1;
  static final Random _random = Random();
  int totalPages;

  AnalysisRepositoryFake() : totalPages = _random.nextInt(10) + 4;

  final StreamController<AnalysisIdList> _analysisIdsController =
      StreamController.broadcast();
  List<int> _cachedIds = [];
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
    ),
  );
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
  final List<Analysis> _analyses = [];
  Iterable<Analysis> generateAnalyses({int count = 6}) sync* {
    final random = Random();
    final now = DateTime.now();

    for (var i = 0; i < count; i++) {
      final id = random.nextInt(100000);
      final name = "Larva experiment ${getRandomString(random.nextInt(20))}";
      final status = AnalysisProgressStatus
          .values[random.nextInt(AnalysisProgressStatus.values.length)];
      final thumbnail = "https://picsum.photos/seed/$id/640/360";

      var analysis = Analysis(
        id: id,
        uploadedAt: now.subtract(Duration(minutes: random.nextInt(10000))),
        name: name,
        thumbnailUrl: thumbnail,
        status: status,
        analysedAt: status == AnalysisProgressStatus.completed ? now : null,
      );

      if (analysis.status == AnalysisProgressStatus.completed) {
        analysis = _applyRandomSubstances(analysis);
      }

      yield analysis;
    }
  }

  @override
  TaskEither<Failure, AnalysisIdList> fetchVideoIds({
    String? nextPage,
    AnalysisSort? sort,
    AnalysisFilter? filter,
  }) {
    final int currentPage = this.nextPage;
    this.nextPage += 1;
    final bool isFirstPage = currentPage == 0;
    final bool shouldGenerateNew =
        (isFirstPage && _analyses.isEmpty) ||
        (!isFirstPage && currentPage < totalPages);

    return TaskEither.tryCatch(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (shouldGenerateNew) {
        _analyses.addAll(generateAnalyses().toList());
      }

      List<Analysis> copy = List.from(_analyses);

      if (filter != null) {
        copy = filter.applyFilter(copy);
      }

      if (sort != null) {
        copy.sort((a, b) {
          final comparison = _compareByField(a, b, sort.field);
          return sort.order == SortOrder.ascending ? comparison : -comparison;
        });
      } else {
        copy.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
      }

      final ids = copy.map((a) => a.id).toList();
      _cachedIds = ids;

      final hasNext = currentPage < totalPages;
      final nextPageToken = hasNext ? (currentPage + 1).toString() : null;

      final result = AnalysisIdList(ids: ids, nextPage: nextPageToken);
      _analysisIdsController.add(result);

      return result;
    }, (error, _) => UnknownAnalysisFailure(message: error.toString()));
  }

  @override
  TaskEither<Failure, Analysis> fetchVideoDetailsById(int id) {
    final Random random = Random();
    return TaskEither.tryCatch(
      () async {
        await Future.delayed(Duration(milliseconds: random.nextInt(250)));
        return _analyses.firstWhere((video) => video.id == id);
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
          final index = _analyses.indexWhere((v) => v.id == id);
          _analyses[index] = v;
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
      final index = _analyses.indexWhere((v) => v.id == id);
      _analyses[index] = updatedVideo;
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
    void Function(double progress)? onProgress,
  }) {
    return TaskEither.tryCatch(
      () async {
        const totalChunks = 20;
        for (int i = 1; i <= totalChunks; i++) {
          await Future.delayed(const Duration(milliseconds: 150));
          final progress = i / totalChunks;
          onProgress?.call(progress);
        }
        await Future.delayed(const Duration(milliseconds: 300));
        final nextId =
            (_analyses.isEmpty ? 0 : _analyses.map((e) => e.id).reduce(max)) +
            1;
        _analyses.insert(
          0,
          Analysis(
            id: nextId,
            uploadedAt: DateTime.now(),
            name: title,
            thumbnailUrl: "https://picsum.photos/seed/$nextId/640/360",
          ),
        );
        _cachedIds = _analyses.map((a) => a.id).toList();

        _analysisIdsController.add(AnalysisIdList(ids: _cachedIds));
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

  int _compareByField(Analysis a, Analysis b, AnalysisField field) {
    return switch (field) {
      AnalysisField.title => _compareNullableStrings(a.name, b.name),
      AnalysisField.createdAt => a.uploadedAt.compareTo(b.uploadedAt),
      AnalysisField.status => a.status.index.compareTo(b.status.index),
    };
  }

  int _compareNullableStrings(String? a, String? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  @override
  TaskEither<Failure, bool> deleteAnalysis({required int id}) {
    return TaskEither.tryCatch(
      () {
        final idx = _analyses.indexWhere((a) => a.id == id);
        if (idx == -1) {
          return Future.delayed(
            Duration(milliseconds: _random.nextInt(1500)),
            () => false,
          );
        }
        _analyses.removeAt(idx);
        _cachedIds = _analyses.map((a) => a.id).toList();
        _analysisIdsController.add(AnalysisIdList(ids: _cachedIds));
        return Future.delayed(
          Duration(milliseconds: _random.nextInt(1500)),
          () => true,
        );
      },
      (error, stackTrace) {
        return const Failure(message: "Invalid id");
      },
    );
  }

  @override
  Stream<AnalysisIdList> get analysisIdsStream => _analysisIdsController.stream;

  @override
  void dispose() {
    _analysisIdsController.close();
  }
}
