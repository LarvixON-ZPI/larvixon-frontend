import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AnalysisIdList extends Equatable {
  final List<int> ids;
  final String? nextPage;
  bool get hasMore => nextPage != null;

  const AnalysisIdList({required this.ids, this.nextPage});

  @override
  List<Object?> get props => [ids, nextPage];
}
