import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/analysis/presentation/analysis_details_page.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/progress_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/results_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/status_row.dart';
import 'package:larvixon_frontend/src/common/extensions/date_format_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnalysisCard extends StatefulWidget {
  final int videoId;
  const AnalysisCard({super.key, required this.videoId});

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
            ..add(FetchAnalysisDetails(videoId: widget.videoId)),
      child: BlocConsumer<AnalysisBloc, AnalysisState>(
        listenWhen: (previous, current) {
          return previous.progress != current.progress;
        },
        listener: (context, state) {},
        builder: (context, state) {
          final video = state.video;
          final hasResults = state.video?.results?.isNotEmpty ?? false;
          final enabled =
              state.status == AnalysisStatus.loading || state.video == null;

          return GestureDetector(
            onTap: () => context.push(
              LarvaVideoDetailsPage.routeName,
              extra: {
                'videoId': widget.videoId,
                'bloc': context.read<AnalysisBloc>(),
              },
            ),
            child: MouseRegion(
              child: Skeletonizer(
                enabled: enabled,
                child: CustomCard(
                  child: Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [StatusRow(video: state.video)],
                        ),
                        if (state.video?.name != null)
                          Text(
                            state.video!.name!,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (video != null)
                          Text(
                            "${video.uploadedAt.formattedDateOnly} ${video.uploadedAt.formattedTimeOnly}",
                          ),
                        if (hasResults)
                          Expanded(
                            child: ResultsSection(
                              results: state.video!.results!,
                            ),
                          ),

                        ProgressSection(
                          video: state.video,
                          progress: state.progress,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
