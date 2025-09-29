class LarvaVideoIdList {
  final List<int> ids;
  final String? nextPage;
  bool get hasMore => nextPage != null;

  LarvaVideoIdList({required this.ids, this.nextPage});
}
