import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/animated_confidence_bar.dart';

class AnalysisResultsEntry extends StatelessWidget {
  final String label;
  final double confidence;
  const AnalysisResultsEntry({
    super.key,
    required this.label,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.0,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          AnimatedConfidenceBar(
            confidence: confidence,
            includePercentage: true,
          ),
        ],
      ),
    );
  }
}
