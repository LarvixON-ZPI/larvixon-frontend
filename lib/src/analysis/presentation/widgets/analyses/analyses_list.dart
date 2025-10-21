import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analysis_grid.dart';

class AnalysesList extends StatelessWidget {
  final ScrollController scrollController;
  final List<int> analysesIds;
  const AnalysesList({
    required this.scrollController,
    required this.analysesIds,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: SafeArea(child: LarvaVideoGrid(analysesIds: analysesIds)),
    );
  }
}
