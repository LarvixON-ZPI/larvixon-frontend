import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

part 'analysis_list_state.dart';

class AnalysisListCubit extends Cubit<AnalysisListState> {
  final AnalysisRepository _repository;
  AnalysisListCubit(this._repository) : super(AnalysisListState());

  bool get canLoadMore =>
      state.hasMore && state.status != AnalysisListStatus.loading;

  void fetchNewlyUploadedVideo({required int id}) async {
    final currentIds = state.videoIds;
    if (currentIds.contains(id)) return;
    final updatedIds = [id, ...currentIds];
    emit(state.copyWith(videoIds: updatedIds));
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

  Future<void> loadAnalyses({bool refresh = false}) async {
    emit(
      state.copyWith(status: AnalysisListStatus.loading, errorMessage: null),
    );
    final result = await _repository.fetchVideoIds(sort: state.sort).run();

    result.match(
      (failire) => emit(
        state.copyWith(
          status: AnalysisListStatus.error,
          errorMessage: failire.message,
        ),
      ),
      (success) {
        final ids = refresh
            ? success.ids
            : {...state.videoIds, ...success.ids}.toList();

        final nextPage = success.nextPage;
        emit(
          state.copyWith(
            status: AnalysisListStatus.success,
            videoIds: ids,
            errorMessage: null,
            page: state.page + 1,
            nextPage: nextPage,
            hasMore: nextPage != null,
          ),
        );
      },
    );
  }

  void updateSort(AnalysisSort sort) {
    emit(state.copyWith(sort: sort));
    loadAnalyses(refresh: true);
  }

  void toggleSortOrder() {
    final newOrder = state.sort.order == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;

    updateSort(state.sort.copyWith(order: newOrder));
  }
}
