import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/larva_video_repository.dart';

part 'larva_video_list_state.dart';

class LarvaVideoListCubit extends Cubit<LarvaVideoListState> {
  final LarvaVideoRepository _repository;
  LarvaVideoListCubit(this._repository) : super(LarvaVideoListState());

  void fetchNewlyUploadedVideo({required int id}) async {
    final currentIds = state.videoIds;
    if (!currentIds.contains(id)) {
      final updatedIds = [id, ...currentIds];
      emit(state.copyWith(videoIds: updatedIds));
    }
  }

  Future<void> fetchVideoList() async {
    if (!state.hasMore) return;
    if (state.status == LarvaVideoListStatus.loading) return;
    emit(state.copyWith(status: LarvaVideoListStatus.loading));

    final result = await _repository
        .fetchVideoIds(nextPage: state.nextPage)
        .run();

    result.match(
      (failure) {
        emit(
          state.copyWith(
            status: LarvaVideoListStatus.error,
            errorMessage: failure.message,
          ),
        );
      },

      (success) {
        final (ids, nextPage) = success;
        final merged = {...state.videoIds, ...ids}.toList();
        emit(
          state.copyWith(
            status: LarvaVideoListStatus.success,
            videoIds: merged,
            page: state.page + 1,
            nextPage: nextPage,
            hasMore: nextPage != null,
          ),
        );
      },
    );
  }
}
