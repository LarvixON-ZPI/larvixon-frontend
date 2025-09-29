import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/analysis/presentation/analysis_details_page.dart';
import 'package:larvixon_frontend/src/analysis/presentation/details_card/progress_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/details_card/results_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/details_card/status_row.dart';
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
          final title = state.video?.name ?? '';

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
                  color: Colors.grey[200],
                  useWrap: false,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),
                        StatusRow(video: state.video),
                      ],
                    ),
                    if (state.video?.name != null)
                      Text(
                        state.video?.name ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (video != null)
                      Text(
                        "${video.uploadedAt.formattedDateOnly} ${video.uploadedAt.formattedTimeOnly}",
                      ),
                    if (hasResults)
                      ResultsSection(results: state.video!.results!),
                    (state.video?.status == AnalysisProgressStatus.failed ||
                            state.video?.status ==
                                AnalysisProgressStatus.completed)
                        ? SizedBox.shrink()
                        : Spacer(),
                    ProgressSection(
                      video: state.video,
                      progress: state.progress,
                    ),
                  ],
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

class _DateText extends StatelessWidget {
  final DateTime? date;
  final String text;
  const _DateText({super.key, required this.date, required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },

      child: Text("$text ${date?.toLocal().formattedDateOnly ?? ''}"),
    );
  }
}
