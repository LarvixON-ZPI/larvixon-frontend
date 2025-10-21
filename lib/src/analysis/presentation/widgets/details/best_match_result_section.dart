import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';
import 'package:larvixon_frontend/src/common/extensions/color_gradient.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class BestMatchResultSection extends StatelessWidget {
  const BestMatchResultSection({required this.results});
  final AnalysisResults results;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${context.translate.mostConfidentResult}: ",
            style: Theme.of(context).textTheme.headlineSmall,
            overflow: TextOverflow.ellipsis,
          ),

          Text(
            "${results.first.$1} (${(results.first.$2 * 100).toStringAsFixed(2)}%)",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: ColorGradientExtension.gradient(score: results.first.$2),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
