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
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
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
      child: BlocConsumer<AnalysisBloc, AnalysisState>(
        listenWhen: (previous, current) {
          return previous.progress != current.progress;
        },
        listener: (context, state) {},
        builder: (context, state) {
          final analysis = state.analysis;
          final hasResults = state.analysis?.results?.isNotEmpty ?? false;
          final hasImage = analysis?.thumbnailUrl != null;
          final enabled =
              state.status == AnalysisStatus.loading || state.analysis == null;

          return InkWell(
            onTap: () => context.push(
              "${AnalysesOverviewPage.route}/${widget.analysisId}",
            ),
            child: Skeletonizer(
              enabled: enabled,
              child: CustomCard(
                color: Colors.transparent,
                // TODO: Need to rethink that
                // background: hasImage
                //     ? Image.network(
                //         analysis!.thumbnailUrl!,
                //         fit: BoxFit.cover,
                //         opacity: const AlwaysStoppedAnimation(0.4),
                //         width: double.infinity,
                //         height: double.infinity,
                //         errorBuilder: (context, error, stackTrace) {
                //           return const SizedBox.shrink();
                //         },
                //       )
                //     : null,
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [StatusRow(analysis: state.analysis)],
                      ),
                      if (state.analysis?.name != null)
                        Text(
                          state.analysis!.name!,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (analysis != null)
                        Text(
                          "${analysis.uploadedAt.formattedDateOnly} ${analysis.uploadedAt.formattedTimeOnly}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
