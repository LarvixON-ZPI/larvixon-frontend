import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class AnalysisDetailsPage extends StatelessWidget {
  static const String route = ':analysisId';
  static const String name = 'analysis-details';

  const AnalysisDetailsPage({super.key, required this.analysisId, this.bloc});

  final int? analysisId;
  final AnalysisBloc? bloc;

  Color barColor(double confidence) {
    if (confidence < 0.5) {
      return Color.lerp(Colors.red, Colors.orange, confidence / 0.5)!;
    } else {
      return Color.lerp(Colors.orange, Colors.green, (confidence - 0.5) / 0.5)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (analysisId == null) {
      return const _InvalidIdView();
    }
    final int id = analysisId!;
    final provider = bloc != null
        ? BlocProvider.value(
            value: bloc!,
            child: const _AnalysisDetailsContent(),
          )
        : BlocProvider(
            create: (context) =>
                AnalysisBloc(repository: context.read<AnalysisRepository>())
                  ..add(FetchAnalysisDetails(analysisId: id)),
            child: const _AnalysisDetailsContent(),
          );

    return provider;
  }
}

class _AnalysisDetailsContent extends StatelessWidget {
  const _AnalysisDetailsContent();

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
        if (state.analysis == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final video = state.analysis!;
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
                          description: Text(
                            "${(r.$2 * 100).toStringAsFixed(1)}%",
                          ),
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

class _InvalidIdView extends StatelessWidget {
  const _InvalidIdView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('Analysis ID is missing')));
  }
}
