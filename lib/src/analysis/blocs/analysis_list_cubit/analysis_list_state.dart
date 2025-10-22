part of 'analysis_list_cubit.dart';

enum AnalysisListStatus { initial, loading, loadingMore, success, error }

final class AnalysisListState extends Equatable {
  final AnalysisListStatus status;
  final List<int> analysesIds;
  final String? errorMessage;
  final String? nextPage;
  final int page;
  final bool hasMore;
  final AnalysisSort sort;
  const AnalysisListState({
    this.status = AnalysisListStatus.initial,
    this.analysesIds = const [],
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
    this.nextPage,
    this.sort = const AnalysisSort.defaultSorting(),
  });

  AnalysisListState copyWith({
    AnalysisListStatus? status,
    List<int>? videoIds,
    String? errorMessage,
    int? page,
    bool? hasMore,
    String? nextPage,
    AnalysisSort? sort,
  }) {
    return AnalysisListState(
      status: status ?? this.status,
      analysesIds: videoIds ?? analysesIds,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [
    status,
    analysesIds,
    errorMessage,
    page,
    hasMore,
    nextPage,
    sort,
  ];
}
