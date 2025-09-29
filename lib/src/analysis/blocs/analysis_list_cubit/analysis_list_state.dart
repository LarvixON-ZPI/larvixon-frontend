part of 'analysis_list_cubit.dart';

enum AnalysisListStatus { initial, loading, loadingMore, success, error }

final class AnalysisListState extends Equatable {
  final AnalysisListStatus status;
  final List<int> videoIds;
  final String? errorMessage;
  final String? nextPage;
  final int page;
  final bool hasMore;
  const AnalysisListState({
    this.status = AnalysisListStatus.initial,
    this.videoIds = const [],
    this.errorMessage,
    this.page = 1,
    this.hasMore = true,
    this.nextPage,
  });

  AnalysisListState copyWith({
    AnalysisListStatus? status,
    List<int>? videoIds,
    String? errorMessage,
    int? page,
    bool? hasMore,
    String? nextPage,
  }) {
    return AnalysisListState(
      status: status ?? this.status,
      videoIds: videoIds ?? this.videoIds,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    videoIds,
    errorMessage,
    page,
    hasMore,
    nextPage,
  ];
}
