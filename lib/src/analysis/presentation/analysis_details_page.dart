import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class LarvaVideoDetailsPage extends StatelessWidget {
  static const String routeName = '/video_details';
  static const String name = 'video-details';

  const LarvaVideoDetailsPage({super.key});

  Color barColor(double confidence) {
    if (confidence < 0.5) {
      return Color.lerp(Colors.red, Colors.orange, confidence / 0.5)!;
    } else {
      return Color.lerp(Colors.orange, Colors.green, (confidence - 0.5) / 0.5)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      builder: (context, state) {
        if (state.video == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final video = state.video!;
        return SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (video.results?.isNotEmpty ?? false)
                  Wrap(
                    spacing: 8,
                    children: [
                      ...video.results!.map(
                        (r) => CustomCard(
                          title: Text(r.$1),
                          description: Text("${(r.$2 * 100).toStringAsFixed(1)}%"),
                          color: barColor(r.$2).withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
