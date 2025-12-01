import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/animated_confidence_bar.dart';
import 'package:larvixon_frontend/src/common/extensions/color_gradient.dart';
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
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        context.translate.substance,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        context.translate.confidence,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(12), child: Text("")),
                  ],
                ),
                ...results.asMap().entries.map((entry) {
                  final index = entry.key;
                  final (substance, confidence) = entry.value;
                  final isLast = index == results.length - 1;

                  return TableRow(
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? Colors.transparent
                          : theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.3),
                      borderRadius: isLast
                          ? const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            )
                          : null,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: SelectableText(
                          substance,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: SelectableText(
                          "${(confidence * 100).toStringAsFixed(1)}%",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorGradientExtension.gradient(
                              score: confidence,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: AnimatedConfidenceBar(confidence: confidence),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
