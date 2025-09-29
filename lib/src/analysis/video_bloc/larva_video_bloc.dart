import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/larva_video.dart';

import '../domain/larva_video_repository.dart';

part 'larva_video_event.dart';
part 'larva_video_state.dart';

class LarvaVideoBloc extends Bloc<LarvaVideoEvent, LarvaVideoState> {
  final LarvaVideoRepository repository;
  LarvaVideoBloc({required this.repository}) : super(LarvaVideoState()) {
    on<FetchLarvaVideoDetails>(_fetchLarvaVideoDetails);
  }

  FutureOr<void> _fetchLarvaVideoDetails(
    FetchLarvaVideoDetails event,
    Emitter<LarvaVideoState> emit,
  ) async {
    emit(state.copyWith(status: LarvaVideoBlocStatus.loading));

    await emit.forEach<Either<Failure, LarvaVideo>>(
      repository.watchVideoProgressById(id: event.videoId),
      onData: (either) => either.match(
        (failure) => state.copyWith(
          status: LarvaVideoBlocStatus.error,
          errorMessage: failure.message,
        ),
        (video) => state.copyWith(
          status: LarvaVideoBlocStatus.success,
          video: video,
          progress: video.status.progressValue,
          errorMessage: null,
        ),
      ),
      onError: (error, stackTrace) {
        return state.copyWith(
          status: LarvaVideoBlocStatus.error,
          errorMessage: "Unexpected stream error: $error",
        );
      },
    );
  }
}
