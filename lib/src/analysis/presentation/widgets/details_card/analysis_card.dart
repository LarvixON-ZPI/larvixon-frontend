import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/progress_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/results_section.dart';
import 'package:larvixon_frontend/src/common/extensions/date_format_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnalysisCard extends StatelessWidget {
  final int analysisId;
  const AnalysisCard({super.key, required this.analysisId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(analysisId),
      create: (context) =>
          AnalysisBloc(repository: context.read<AnalysisRepository>())
            ..add(FetchAnalysisDetails(analysisId: analysisId)),
      child: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          final analysis = state.analysis;
          final hasResults = state.analysis?.results?.isNotEmpty ?? false;
          final status =
              state.analysis?.status ?? AnalysisProgressStatus.pending;
          final skeletonEnabled =
              state.status == AnalysisStatus.loading || state.analysis == null;

          return InkWell(
            onTap: () =>
                context.push("${AnalysesOverviewPage.route}/$analysisId"),
            child: Skeletonizer(
              enabled: skeletonEnabled,
              child: CustomCard(
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _HeaderRow(analysis: analysis),
                      const Divider(),
                      if (state.analysis?.name case final name?) ...[
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(),
                      ],
                      Expanded(
                        child: Skeleton.ignore(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: hasResults
                                ? ResultsSection(
                                    key: const ValueKey("results"),
                                    results: state.analysis!.results!,
                                  )
                                : ProgressSection(
                                    key: const ValueKey("progress"),

                                    status: status,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).withOnHoverEffect,
            ),
          );
        },
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.analysis});

  final Analysis? analysis;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: analysis?.id != null
              ? Text(
                  "#${analysis!.id}",
                  style: Theme.of(context).textTheme.titleLarge,
                )
              : const SizedBox(height: 24),
        ),

        Expanded(
          flex: 2,
          child: analysis != null
              ? Text(
                  analysis!.uploadedAt.formattedDateOnly,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.right,
                )
              : const SizedBox(height: 24),
        ),
      ],
    );
  }
}
