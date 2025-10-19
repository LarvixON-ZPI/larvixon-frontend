import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/status_row.dart';
import 'package:larvixon_frontend/src/common/extensions/date_format_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class AnalysisDetailsPage extends StatelessWidget {
  static const String route = ':analysisId';
  static const String name = 'analysis-details';

  const AnalysisDetailsPage({super.key, required this.analysisId, this.bloc});

  final int? analysisId;
  final AnalysisBloc? bloc;

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

  Color confidenceGradient(double confidence) {
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
        if (_isLoading(state)) {
          return _LoadingView();
        }

        final analysis = state.analysis!;
        return Center(
          child: SingleChildScrollView(
            child: CustomCard(
              constraints: BoxConstraints(maxWidth: 800),
              title: Text(
                "Analysis details",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      Text(
                        "Title: ",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        "${analysis.name ?? 'Not set'}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Text(
                        "Status: ",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      StatusRow(video: analysis),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Text(
                        "Created at: ",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        "${analysis.uploadedAt.formattedDateTime}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  if (analysis.analysedAt != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Analysed at: ",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          "${analysis.analysedAt!.formattedDateTime}",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  if (_hasResults(analysis))
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        Wrap(
                          alignment: WrapAlignment.start,

                          children: [
                            Text(
                              "Most confident result: ",
                              style: Theme.of(context).textTheme.headlineSmall,
                              overflow: TextOverflow.ellipsis,
                            ),

                            Text(
                              "${analysis.results!.first.$1} (${(analysis.results!.first.$2 * 100).toStringAsFixed(2)}%)",
                              style: Theme.of(context).textTheme.headlineSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        if (analysis.results!.length > 1)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              Text(
                                "All results",
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 8.0),

                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ...analysis.results!.map((entry) {
                                    final (substance, confidence) = entry;
                                    return Chip(
                                      backgroundColor: confidenceGradient(
                                        confidence,
                                      ).withValues(alpha: 0.5),

                                      label: Column(
                                        children: [
                                          Text("$substance"),
                                          Text(
                                            "${(confidence * 100).toStringAsFixed(2)}%",
                                          ),
                                        ],
                                      ),
                                    ).withOnHoverEffect;
                                  }),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _hasResults(Analysis analysis) => analysis.results?.isNotEmpty != null;

  bool _isLoading(AnalysisState state) =>
      state.analysis == null && state.status == AnalysisStatus.loading;
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class _InvalidIdView extends StatelessWidget {
  const _InvalidIdView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('Analysis ID is missing')));
  }
}
