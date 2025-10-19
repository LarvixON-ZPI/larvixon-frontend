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
        maxCrossAxisExtent: 500,
        childAspectRatio: 5 / 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: analysesIds.length,
      itemBuilder: (context, index) {
        final analysisId = analysesIds[index];
        return AnalysisCard(key: ValueKey(analysisId), analysisId: analysisId);
      },
      findChildIndexCallback: (key) {
        if (key is ValueKey<int>) {
          return analysesIds.indexOf(key.value);
        }
        return null;
      },
    );
  }
}
