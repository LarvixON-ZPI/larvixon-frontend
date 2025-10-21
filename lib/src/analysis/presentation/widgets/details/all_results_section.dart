import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/animated_confidence_bar.dart';
import 'package:larvixon_frontend/src/common/extensions/color_gradient.dart';
import 'package:larvixon_frontend/src/common/extensions/default_padding.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class AllResultsSection extends StatelessWidget {
  const AllResultsSection({required this.results});
  final AnalysisResults results;
  Future<Object?> _showSubstanceDetails(
    BuildContext context,
    String substance,
    double confidence,
  ) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Substance Details",
      barrierDismissible: true,
      pageBuilder: (context, anim, secondaryAnimation) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: CustomCard(
                    title: Text(
                      substance,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Divider(),
                        Row(
                          spacing: 8.0,
                          children: [
                            Icon(
                              Icons.percent,
                              color: ColorGradientExtension.gradient(
                                score: confidence,
                              ),
                            ),
                            Text(
                              "${context.translate.confidence}: ${(confidence * 100).toStringAsFixed(2)}%",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).withDefaultPagePadding;
      },
    );
  }

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
            return InkWell(
              onTap: () {
                _showSubstanceDetails(context, substance, confidence);
              },
              child: Container(
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
                        child: Text(
                          substance,
                          style: theme.textTheme.titleLarge,
                        ),
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
              ),
            ).withOnHoverEffect;
          }),
        ],
      ),
    );
  }
}
