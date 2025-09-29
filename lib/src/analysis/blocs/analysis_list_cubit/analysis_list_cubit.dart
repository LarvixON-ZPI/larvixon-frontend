import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';

part 'analysis_list_state.dart';

class AnalysisListCubit extends Cubit<AnalysisListState> {
  final AnalysisRepository _repository;
  AnalysisListCubit(this._repository) : super(AnalysisListState());

  bool get canLoadMore =>
      state.hasMore && state.status != AnalysisListStatus.loading;

  void fetchNewlyUploadedVideo({required int id}) async {
    final currentIds = state.videoIds;
    if (!currentIds.contains(id)) {
      final updatedIds = [id, ...currentIds];
      emit(state.copyWith(videoIds: updatedIds));
    }
  }

  Future<void> fetchVideoList() async {
    emit(state.copyWith(status: AnalysisListStatus.loading));

    final result = await _repository
        .fetchVideoIds(nextPage: state.nextPage)
        .run();

    result.match(
      (failure) {
        emit(
          state.copyWith(
            status: AnalysisListStatus.error,
            errorMessage: failure.message,
          ),
        );
      },

      (success) {
        final ids = success.ids;
        final nextPage = success.nextPage;
        final merged = {...state.videoIds, ...ids}.toList();

        emit(
          state.copyWith(
            status: AnalysisListStatus.success,
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
