import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/analysis_card.dart';

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
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverSafeArea(
          sliver: SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600,
                childAspectRatio: 4 / 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnalysisCard(
                    key: ValueKey(analysesIds[index]),
                    analysisId: analysesIds[index],
                  );
                },
                childCount: analysesIds.length,
                findChildIndexCallback: (Key key) {
                  if (key is ValueKey<int>) {
                    final index = analysesIds.indexOf(key.value);
                    return index >= 0 ? index : null;
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
