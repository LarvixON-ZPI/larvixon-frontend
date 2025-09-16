import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/domain/larva_video_repository.dart';
import 'package:larvixon_frontend/src/analysis/larva_video_status.dart';
import 'package:larvixon_frontend/src/analysis/presentation/detailsCard/progress_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/detailsCard/results_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/detailsCard/status_row.dart';
import 'package:larvixon_frontend/src/analysis/presentation/larva_video_details_page.dart';
import 'package:larvixon_frontend/src/analysis/video_bloc/larva_video_bloc.dart';
import 'package:larvixon_frontend/src/common/extensions/date_format_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LarvaVideoCard extends StatefulWidget {
  final int videoId;
  const LarvaVideoCard({super.key, required this.videoId});

  @override
  State<LarvaVideoCard> createState() => _LarvaVideoCardState();
}

class _LarvaVideoCardState extends State<LarvaVideoCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      key: ValueKey(widget.key),
      create: (context) =>
          LarvaVideoBloc(repository: context.read<LarvaVideoRepository>())
            ..add(FetchLarvaVideoDetails(videoId: widget.videoId)),
      child: BlocConsumer<LarvaVideoBloc, LarvaVideoState>(
        listenWhen: (previous, current) {
          return previous.progress != current.progress;
        },
        listener: (context, state) {},
        builder: (context, state) {
          final video = state.video;
          final hasResults = state.video?.results?.isNotEmpty ?? false;
          final enabled =
              state.status == LarvaVideoBlocStatus.loading ||
              state.video == null;

          return GestureDetector(
            onTap: () => context.push(
              LarvaVideoDetailsPage.routeName,
              extra: {
                'videoId': widget.videoId,
                'bloc': context.read<LarvaVideoBloc>(),
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

                    Text(
                      state.video?.name ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (video != null)
                      Text(
                        "${video.uploadedAt.formattedDateOnly} ${video.uploadedAt.formattedTimeOnly}",
                      ),
                    if (hasResults)
                      ResultsSection(results: state.video!.results!),
                    (state.video?.status == LarvaVideoStatus.error ||
                            state.video?.status == LarvaVideoStatus.analysed)
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
