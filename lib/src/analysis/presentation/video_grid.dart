import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/presentation/detailsCard/larva_video_card.dart';
import 'package:larvixon_frontend/src/analysis/video_list_cubit/larva_video_list_cubit.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';

class LarvaVideoGrid extends StatefulWidget {
  const LarvaVideoGrid({super.key});

  @override
  State<LarvaVideoGrid> createState() => _LarvaVideoGridState();
}

class _LarvaVideoGridState extends State<LarvaVideoGrid> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LarvaVideoListCubit, LarvaVideoListState>(
      builder: (context, state) {
        if (state.status == LarvaVideoListStatus.error) {
          return const Center(child: Text('Error fetching videos'));
        }
        return GridView.custom(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            childAspectRatio: 5 / 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
              final videoId = state.videoIds[index];

              return LarvaVideoCard(
                key: ValueKey(videoId),
                videoId: videoId,
              ).withOnHoverEffect;
            },
            childCount: state.videoIds.length,
            findChildIndexCallback: (key) {
              if (key is ValueKey<int>) {
                return state.videoIds.indexOf(key.value);
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
