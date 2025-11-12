import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/animated_confidence_bar.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class AllResultsSection extends StatelessWidget {
  const AllResultsSection({super.key, required this.results});
  final AnalysisResults results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${context.translate.detectedSubstances(results.length)} (${results.length})",
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...results.asMap().entries.map((entry) {
            final i = entry.key;
            final (substance, confidence) = entry.value;
            return Container(
              color: i.isEven
                  ? theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.8,
                    )
                  : Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(substance, style: theme.textTheme.titleLarge),
                    ),
                    Expanded(
                      flex: 3,
                      child: AnimatedConfidenceBar(
                        confidence: confidence,
                        includePercentage: true,
                        textStyle: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ).withOnHoverEffect;
          }),
        ],
      ),
    );
  }
}
