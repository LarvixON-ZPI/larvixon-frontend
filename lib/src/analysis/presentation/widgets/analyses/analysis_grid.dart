import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/analysis_card.dart';

class LarvaVideoGrid extends StatelessWidget {
  final List<int> analysesIds;

  const LarvaVideoGrid({super.key, required this.analysesIds});

  @override
  Widget build(BuildContext context) {
    if (analysesIds.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No analyses found'),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 600,
        childAspectRatio: 4 / 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: analysesIds.length,
      itemBuilder: (context, index) {
        final analysisId = analysesIds[index];
        return AnalysisCard(key: ValueKey(analysisId), analysisId: analysisId);
      },
      findChildIndexCallback: (Key key) {
        if (key is ValueKey<int>) {
          final index = analysesIds.indexOf(key.value);
          return index >= 0 ? index : null;
        }
        return null;
      },
    );
  }
}
