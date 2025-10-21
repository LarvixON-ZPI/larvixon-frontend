import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analysis_grid.dart';

class AnalysesList extends StatelessWidget {
  final ScrollController scrollController;
  final AnalysisListState state;
  const AnalysesList({required this.scrollController, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: SafeArea(
        child: Column(
          children: [
            LarvaVideoGrid(analysesIds: state.videoIds),
            if (state.status == AnalysisListStatus.loadingMore)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            if (state.errorMessage != null && state.videoIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
