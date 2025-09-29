import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/presentation/detailsCard/analysis_card.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class LarvaVideoGrid extends StatefulWidget {
  const LarvaVideoGrid({super.key});

  @override
  State<LarvaVideoGrid> createState() => _LarvaVideoGridState();
}

class _LarvaVideoGridState extends State<LarvaVideoGrid> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      final cubit = context.read<LarvaVideoListCubit>();
      if (cubit.state.status != LarvaVideoListStatus.loading) {
        cubit.fetchVideoList();
      }
    }
  }

  void _checkScrollability(double viewportHeight) {
    final cubit = context.read<LarvaVideoListCubit>();
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent <= viewportHeight &&
        cubit.state.hasMore &&
        cubit.state.status != LarvaVideoListStatus.loading) {
      cubit.fetchVideoList().then((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkScrollability(viewportHeight);
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _getChildrenCount() {
    final state = context.read<LarvaVideoListCubit>().state;
    var count = state.videoIds.length;
    if (state.status == LarvaVideoListStatus.loading ||
        state.status == LarvaVideoListStatus.error) {
      count += 1;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LarvaVideoListCubit, LarvaVideoListState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkScrollability(constraints.maxHeight);
            });

            return GridView.custom(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                childAspectRatio: 5 / 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),

              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < state.videoIds.length) {
                    final videoId = state.videoIds[index];
                    return AnalysisCard(
                      key: ValueKey(videoId),
                      videoId: videoId,
                    ).withOnHoverEffect;
                  }
                  if (state.status == LarvaVideoListStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == LarvaVideoListStatus.error) {
                    return CustomCard(
                      title: context.translate.error,
                      description:
                          state.errorMessage ?? context.translate.unknownError,
                      icon: Icons.error,
                      color: Colors.redAccent,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<LarvaVideoListCubit>()
                                .fetchVideoList();
                          },
                          child: Text(context.translate.retry),
                        ),
                      ],
                    ).withOnHoverEffect;
                  }
                  return null;
                },
                childCount: _getChildrenCount(),
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
      },
    );
  }
}
