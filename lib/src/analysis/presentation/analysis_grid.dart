import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/presentation/details_card/analysis_card.dart';
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
      final cubit = context.read<AnalysisListCubit>();
      if (cubit.canLoadMore) {
        cubit.fetchVideoList();
      }
    }
  }

  void _checkScrollability(double viewportHeight) {
    final cubit = context.read<AnalysisListCubit>();
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent <= viewportHeight &&
        cubit.canLoadMore &&
        cubit.state.status != AnalysisListStatus.error) {
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
    final state = context.read<AnalysisListCubit>().state;
    var count = state.videoIds.length;
    if (state.status == AnalysisListStatus.loading ||
        state.status == AnalysisListStatus.error) {
      count += 1;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisListCubit, AnalysisListState>(
      builder: (context, state) {
        final String errorMessage =
            state.errorMessage ?? context.translate.unknownError;
        return LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkScrollability(constraints.maxHeight);
            });

            return GridView.custom(
              controller: _scrollController,

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
                    );
                  }
                  if (state.status == AnalysisListStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == AnalysisListStatus.error) {
                    return CustomCard(
                      title: Text(context.translate.error),
                      description: Text(errorMessage),
                      icon: Icon(Icons.error),
                      color: Colors.redAccent,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AnalysisListCubit>().fetchVideoList();
                        },
                        child: Text(context.translate.retry),
                      ),
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
