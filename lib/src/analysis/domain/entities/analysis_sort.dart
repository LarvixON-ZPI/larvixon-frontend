import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_field_enum.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

@immutable
class AnalysisSort extends Equatable {
  final AnalysisField field;
  final SortOrder order;

  const AnalysisSort({required this.field, required this.order});

  const AnalysisSort.defaultSorting()
    : field = AnalysisField.createdAt,
      order = SortOrder.descending;

  AnalysisSort copyWith({AnalysisField? field, SortOrder? order}) {
    return AnalysisSort(field: field ?? this.field, order: order ?? this.order);
  }

  @override
  List<Object?> get props => [field, order];
}
