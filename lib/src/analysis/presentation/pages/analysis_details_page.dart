import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/status_row.dart';
import 'package:larvixon_frontend/src/common/extensions/date_format_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/default_padding.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:larvixon_frontend/src/common/extensions/color_gradient.dart';

class AnalysisDetailsPage extends StatelessWidget {
  static const String route = ':analysisId';
  static const String name = 'analysis-details';

  const AnalysisDetailsPage({super.key, required this.analysisId});

  final int? analysisId;

  @override
  Widget build(BuildContext context) {
    if (analysisId == null) {
      return const _InvalidIdView();
    }
    final int id = analysisId!;

    return BlocProvider(
      key: ValueKey("analysis-$id"),
      create: (context) =>
          AnalysisBloc(repository: context.read<AnalysisRepository>())
            ..add(FetchAnalysisDetails(analysisId: id)),
      child: _AnalysisDetailsContent(analysisId: id),
    );
  }
}

class _AnalysisDetailsContent extends StatelessWidget {
  final int analysisId;
  const _AnalysisDetailsContent({required this.analysisId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      builder: (context, state) {
        if (state.status == AnalysisStatus.initial) {
          context.read<AnalysisBloc>().add(
            FetchAnalysisDetails(analysisId: analysisId),
          );
          return const _LoadingView();
        }
        if (_isLoading(state)) {
          return const _LoadingView();
        }

        final analysis = state.analysis!;
        return Center(
          child: SingleChildScrollView(
            child: CustomCard(
              constraints: const BoxConstraints(maxWidth: 800),
              title: Text(
                context.translate.analysisDetails,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _DetailsSection(analysis: analysis),
                  if (_hasResults(analysis)) ...[
                    const Divider(),
                    _MostProbableSubstanceSection(results: analysis.results!),
                    if (_hasManyResults(analysis)) ...[
                      const Divider(),
                      _AllResultsSection(results: analysis.results!),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _hasManyResults(Analysis analysis) => analysis.results!.length > 1;

  bool _hasResults(Analysis analysis) => analysis.results?.isNotEmpty != null;

  bool _isLoading(AnalysisState state) =>
      state.analysis == null && state.status == AnalysisStatus.loading;
}

class _MostProbableSubstanceSection extends StatelessWidget {
  const _MostProbableSubstanceSection({required this.results});
  final AnalysisResults results;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
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
      ],
    );
  }
}

class _AllResultsSection extends StatelessWidget {
  const _AllResultsSection({required this.results});

  final AnalysisResults results;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${context.translate.detectedSubstances(results.length)}: ",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8.0),

        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: [
            ...results.map((entry) {
              final (substance, confidence) = entry;
              return _SubstanceChip(
                confidence: confidence,
                substance: substance,
              ).withOnHoverEffect;
            }),
          ],
        ),
      ],
    );
  }
}

class _SubstanceChip extends StatelessWidget {
  const _SubstanceChip({required this.confidence, required this.substance});

  final double confidence;
  final String substance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showSubstanceDetails(context);
      },
      child: Chip(
        backgroundColor: ColorGradientExtension.gradient(score: confidence),
        label: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(substance, style: Theme.of(context).textTheme.titleMedium),
            Text("${(confidence * 100).toStringAsFixed(2)}%"),
          ],
        ),
      ),
    );
  }

  Future<Object?> _showSubstanceDetails(BuildContext context) {
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
                      context.translate.detectedSubstances(1),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Icon(
                              FontAwesomeIcons.flaskVial,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Text(
                              substance,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
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
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.analysis});

  final Analysis analysis;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          children: [
            Text(
              "${context.translate.title}: ",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              analysis.name ?? context.translate.notSet,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Text(
              "${context.translate.status}: ",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            StatusRow(analysis: analysis),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Text(
              "${context.translate.createdAt}: ",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              analysis.uploadedAt.formattedDateTime,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        if (analysis.analysedAt != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${context.translate.analysed}: ",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                analysis.analysedAt!.formattedDateTime,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _InvalidIdView extends StatelessWidget {
  const _InvalidIdView();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text('Analysis ID is missing')));
  }
}
