import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';

import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';

part 'analysis_bloc_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalysisRepository repository;
  StreamSubscription<int>? _updatesSubscription;
  StreamSubscription<Either<Failure, Analysis>>? _progressSubscription;

  AnalysisBloc({required this.repository}) : super(const AnalysisState()) {
    on<FetchAnalysisDetails>(_fetchLarvaVideoDetails);
    on<RemoveAnalysis>(_onRemoveAnalysis);
    on<RetryAnalysis>(_onRetryAnalysis);
  }

  FutureOr<void> _onRemoveAnalysis(
    RemoveAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(state.copyWith(status: AnalysisStatus.loading));
    final result = await repository.deleteAnalysis(id: event.analysisId).run();

    result.match(
      (failure) {
        emit(
          state.copyWith(
            status: AnalysisStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (deleted) {
        if (deleted) {
          emit(state.copyWith(status: AnalysisStatus.deleted));
        } else {
          emit(
            state.copyWith(
              status: AnalysisStatus.error,
              errorMessage: "Failed to delete analysis",
            ),
          );
        }
      },
    );
  }

  FutureOr<void> _onRetryAnalysis(
    RetryAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(state.copyWith(status: AnalysisStatus.loading));
    final result = await repository.retryAnalysis(id: event.analysisId).run();

    result.match(
      (failure) {
        emit(
          state.copyWith(
            status: AnalysisStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (analysis) {
        emit(
          state.copyWith(
            status: AnalysisStatus.success,
            analysis: analysis,
            progress: analysis.status.progressValue,
          ),
        );
      },
    );
  }

  FutureOr<void> _fetchLarvaVideoDetails(
    FetchAnalysisDetails event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(state.copyWith(status: AnalysisStatus.loading));

    // Listen for updates to this specific analysis
    _updatesSubscription?.cancel();
    _updatesSubscription = repository.analysisUpdatesStream.listen((updatedId) {
      if (updatedId == event.analysisId && !isClosed) {
        // Restart watching by canceling current subscription and re-adding event
        _progressSubscription?.cancel();
        add(FetchAnalysisDetails(analysisId: event.analysisId, refresh: true));
      }
    });

    await emit.forEach<Either<Failure, Analysis>>(
      repository.watchVideoProgressById(id: event.analysisId),
      onData: (either) => either.match(
        (failure) => state.copyWith(
          status: AnalysisStatus.error,
          errorMessage: failure.message,
        ),
        (video) => state.copyWith(
          status: AnalysisStatus.success,
          analysis: video,
          progress: video.status.progressValue,
        ),
      ),
      onError: (error, stackTrace) {
        return state.copyWith(
          status: AnalysisStatus.error,
          errorMessage: "Unexpected stream error: $error",
        );
      },
    );
  }

  @override
  Future<void> close() {
    _updatesSubscription?.cancel();
    _progressSubscription?.cancel();
    return super.close();
  }
}
