import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';

import '../../domain/repositories/analysis_repository.dart';

part 'analysis_bloc_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalysisRepository repository;
  AnalysisBloc({required this.repository}) : super(AnalysisState()) {
    on<FetchAnalysisDetails>(_fetchLarvaVideoDetails);
  }

  FutureOr<void> _fetchLarvaVideoDetails(
    FetchAnalysisDetails event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(state.copyWith(status: AnalysisStatus.loading));

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
          errorMessage: null,
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
}
