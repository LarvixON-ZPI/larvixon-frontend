import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/analysis_card.dart';

class LarvaVideoGrid extends StatelessWidget {
  final List<int> videoIds;

  const LarvaVideoGrid({super.key, required this.videoIds});

  @override
  Widget build(BuildContext context) {
    if (videoIds.isEmpty) {
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
      itemCount: videoIds.length,
      itemBuilder: (context, index) {
        final videoId = videoIds[index];
        return AnalysisCard(key: ValueKey(videoId), videoId: videoId);
      },
      findChildIndexCallback: (key) {
        if (key is ValueKey<int>) {
          return videoIds.indexOf(key.value);
        }
        return null;
      },
    );
  }
}
