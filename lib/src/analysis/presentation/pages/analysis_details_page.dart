import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/all_results_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/best_match_result_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/header_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/invalid_id_view.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/loading_view.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/meta_section.dart';
import 'package:larvixon_frontend/src/common/widgets/slide_widget.dart';

class AnalysisDetailsPage extends StatelessWidget {
  static const String route = ':analysisId';
  static const String name = 'analysis-details';

  const AnalysisDetailsPage({
    super.key,
    required this.analysisId,
    this.analysisBloc,
  });

  final int? analysisId;
  final AnalysisBloc? analysisBloc;

  @override
  Widget build(BuildContext context) {
    if (analysisId == null) return const InvalidIdView();
    final id = analysisId!;

    return SingleChildScrollView(
      child: Center(child: SafeArea(child: _buildBlocProvider(context, id))),
    );
  }

  Widget _buildBlocProvider(BuildContext context, int id) {
    return analysisBloc != null
        ? BlocProvider<AnalysisBloc>.value(
            key: ValueKey("analysis-$id"),
            value: analysisBloc!,
            child: _AnalysisDetailsContent(analysisId: id),
          )
        : BlocProvider(
            key: ValueKey("analysis-$id"),
            create: (context) =>
                AnalysisBloc(repository: context.read<AnalysisRepository>())
                  ..add(FetchAnalysisDetails(analysisId: id)),
            child: _AnalysisDetailsContent(analysisId: id),
          );
  }
}

class _AnalysisDetailsContent extends StatefulWidget {
  final int analysisId;
  const _AnalysisDetailsContent({required this.analysisId});

  @override
  State<_AnalysisDetailsContent> createState() =>
      _AnalysisDetailsContentState();
}

class _AnalysisDetailsContentState extends State<_AnalysisDetailsContent> {
  bool _isFirstBuild = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      builder: (context, state) {
        if (state.isLoading) return const LoadingView();

        final analysis = state.analysis!;
        final animationConfig = _buildAnimationConfig();

        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderSection(analysis: analysis),
              MetaSection(analysis: analysis),

              if (analysis.hasResults)
                SlideUpTransition(
                  delay: animationConfig.resultsDelay,
                  duration: animationConfig.mainDuration,
                  child: BestMatchResultSection(results: analysis.results!),
                ),
              if (analysis.hasManyResults)
                SlideUpTransition(
                  delay: animationConfig.manyResultsDelay,
                  duration: animationConfig.allResultsDuration,
                  child: AllResultsSection(results: analysis.results!),
                ),
            ],
          ),
        );
      },
    );
  }

  _AnimationConfig _buildAnimationConfig() {
    final config = _isFirstBuild
        ? const _AnimationConfig.zero()
        : const _AnimationConfig.standard();
    _isFirstBuild = false;
    return config;
  }
}

class _AnimationConfig {
  final Duration mainDuration;
  final Duration allResultsDuration;
  final Duration resultsDelay;
  final Duration manyResultsDelay;

  const _AnimationConfig({
    required this.mainDuration,
    required this.allResultsDuration,
    required this.resultsDelay,
    required this.manyResultsDelay,
  });

  const _AnimationConfig.zero()
    : mainDuration = Duration.zero,
      allResultsDuration = Duration.zero,
      resultsDelay = Duration.zero,
      manyResultsDelay = Duration.zero;

  const _AnimationConfig.standard()
    : mainDuration = const Duration(milliseconds: 400),
      allResultsDuration = const Duration(milliseconds: 400),
      resultsDelay = const Duration(milliseconds: 200),
      manyResultsDelay = const Duration(milliseconds: 400);
}

extension on AnalysisState {
  bool get isLoading => status == AnalysisStatus.initial || analysis == null;
}

extension on Analysis {
  bool get hasResults => results?.isNotEmpty ?? false;
  bool get hasManyResults => (results?.length ?? 0) > 1;
}
