import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_filter.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_id_list.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

part 'analysis_list_state.dart';

class AnalysisListCubit extends Cubit<AnalysisListState> {
  final AnalysisRepository _repository;
  late final StreamSubscription<AnalysisIdList> _idsSubscription;
  AnalysisListCubit(this._repository) : super(const AnalysisListState()) {
    _idsSubscription = _repository.analysisIdsStream.listen((ids) {
      if (isClosed) return;
      emit(
        state.copyWith(
          videoIds: ids.ids,
          hasMore: ids.hasMore,
          nextPage: ids.nextPage,
          status: AnalysisListStatus.success,
        ),
      );
    });
  }

  bool get canLoadMore =>
      state.hasMore && state.status != AnalysisListStatus.loading;

  void fetchNewlyUploadedAnalysis({required int id}) async {
    final currentIds = state.analysesIds;
    if (currentIds.contains(id)) return;
    final updatedIds = [id, ...currentIds];
    emit(state.copyWith(videoIds: updatedIds));
  }

  Future<void> fetchAnalysesList() async {
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
        final merged = {...state.analysesIds, ...ids}.toList();

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
    if (isClosed) return;
    if (state.hasMore == false && !refresh) return;
    emit(state.copyWith(status: AnalysisListStatus.loading));
    final result = await _repository
        .fetchVideoIds(
          nextPage: refresh ? null : state.nextPage,
          sort: state.sort,
          filter: state.filter,
        )
        .run();
    if (isClosed) return;
    result.match(
      (failire) => emit(
        state.copyWith(
          status: AnalysisListStatus.error,
          errorMessage: failire.message,
        ),
      ),
      (success) {
        final nextPage = success.nextPage;
        emit(
          state.copyWith(
            status: AnalysisListStatus.success,
            page: state.page + 1,
            nextPage: nextPage,
            hasMore: nextPage != null,
          ),
        );
      },
    );
  }

  void updateSort(AnalysisSort sort) {
    if (sort == state.sort) return;
    emit(state.copyWith(sort: sort));
    loadAnalyses(refresh: true);
  }

  void toggleSortOrder() {
    final newOrder = state.sort.order == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;

    updateSort(state.sort.copyWith(order: newOrder));
  }

  void updateFilter(AnalysisFilter filter) {
    if (filter == state.filter) return;
    emit(state.copyWith(filter: filter));
    loadAnalyses(refresh: true);
  }

  void resetFilter() {
    const emptyFilter = AnalysisFilter.empty();
    if (state.filter != emptyFilter) {
      emit(state.copyWith(filter: emptyFilter));
      loadAnalyses(refresh: true);
    }
  }

  @override
  Future<void> close() {
    _idsSubscription.cancel();
    return super.close();
  }
}
