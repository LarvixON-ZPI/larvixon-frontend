class AnalysisIdList {
  final List<int> ids;
  final String? nextPage;
  bool get hasMore => nextPage != null;

  AnalysisIdList({required this.ids, this.nextPage});
}
