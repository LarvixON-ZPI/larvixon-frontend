import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/progress_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/results_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/status_row.dart';
import 'package:larvixon_frontend/src/common/extensions/date_format_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnalysisCard extends StatefulWidget {
  final int analysisId;
  const AnalysisCard({super.key, required this.analysisId});

  @override
  State<AnalysisCard> createState() => _AnalysisCardState();
}

class _AnalysisCardState extends State<AnalysisCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      key: ValueKey(widget.key),
      create: (context) =>
          AnalysisBloc(repository: context.read<AnalysisRepository>())
            ..add(FetchAnalysisDetails(analysisId: widget.analysisId)),
      child: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          final analysis = state.analysis;
          final hasResults = state.analysis?.results?.isNotEmpty ?? false;
          // ignore: unused_local_variable
          final skeletonEnabled =
              state.status == AnalysisStatus.loading || state.analysis == null;

          return InkWell(
            onTap: () => context.push(
              "${AnalysesOverviewPage.route}/${widget.analysisId}",
            ),
            child: Skeletonizer(
              enabled: skeletonEnabled,

              child: CustomCard(
                color: Theme.of(context).cardColor.withValues(alpha: 0.7),
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: analysis?.id != null
                                  ? Text(
                                      "#${analysis!.id}",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    )
                                  : const SizedBox(height: 24),
                            ),
                          ),

                          Expanded(
                            flex: 3,
                            child: StatusRow(
                              analysis: analysis,
                              showText: false,
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: analysis != null
                                  ? Text(
                                      analysis.uploadedAt.formattedDateOnly,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                      textAlign: TextAlign.right,
                                    )
                                  : const SizedBox(height: 24),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      if (state.analysis?.name case final name?)
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const Divider(),

                      if (hasResults)
                        Expanded(
                          child: ResultsSection(
                            results: state.analysis!.results!,
                          ),
                        ),

                      ProgressSection(
                        video: state.analysis,
                        progress: state.progress,
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

  @override
  bool get wantKeepAlive => true;
}
