import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analysis_add_dialog.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analysis_grid.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/sort_popup_menu.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:larvixon_frontend/src/common/widgets/side_bar_base.dart';

class AnalysesPage extends StatefulWidget {
  const AnalysesPage({super.key});
  static const String route = '/analyses';
  static const String name = 'analyses';

  @override
  State<AnalysesPage> createState() => _AnalysesPageState();
}

class _AnalysesPageState extends State<AnalysesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalysisListCubit>().loadAnalyses();
    });
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<AnalysisListCubit>().loadAnalyses();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: SideBarBase(
            children: [
              IconTextButton(
                icon: FontAwesomeIcons.circlePlus,
                text: context.translate.upload,
                onPressed: () async {
                  await LarvaVideoAddForm.showUploadLarvaVideoDialog(
                    context,
                    context.read<AnalysisListCubit>(),
                  );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocSelector<
                    AnalysisListCubit,
                    AnalysisListState,
                    AnalysisSort
                  >(
                    selector: (state) => state.sort,
                    builder: (context, sort) =>
                        SortPopupMenu(initialSorting: sort),
                  ),
                  Text(
                    context.translate.sort,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {},
                    icon: Icon(
                      FontAwesomeIcons.filter,
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
                  Text(
                    context.translate.filter,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<AnalysisListCubit, AnalysisListState>(
            builder: (context, state) {
              if (_isLoadingView(state)) {
                return const _LoadingView();
              }

              if (_isErrorView(state)) {
                return _ErrorView(errorMessage: state.errorMessage!);
              }
              if (_isEmptyView(state)) {
                return const _EmptyView();
              }

              return SingleChildScrollView(
                controller: _scrollController,
                child: SafeArea(
                  child: Column(
                    children: [
                      LarvaVideoGrid(videoIds: state.videoIds),
                      if (state.status == AnalysisListStatus.loadingMore)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      if (state.errorMessage != null &&
                          state.videoIds.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '${state.errorMessage}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isEmptyView(AnalysisListState state) =>
      state.errorMessage == null && state.videoIds.isEmpty;

  bool _isErrorView(AnalysisListState state) =>
      state.errorMessage != null && state.videoIds.isEmpty;

  bool _isLoadingView(AnalysisListState state) =>
      state.status == AnalysisListStatus.loading && state.videoIds.isEmpty;
}

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onPressed;
  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed?.call,
          icon: Icon(icon, color: Theme.of(context).iconTheme.color!),
        ),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomCard(
        constraints: const BoxConstraints(maxWidth: 400),
        title: Text(
          context.translate.noAnalysesFound,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        child: ElevatedButton(
          onPressed: () => LarvaVideoAddForm.showUploadLarvaVideoDialog(
            context,
            context.read<AnalysisListCubit>(),
          ),
          child: Text(context.translate.clickToUpload),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String errorMessage;
  const _ErrorView({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Text('${context.translate.error}: $errorMessage'),
          ElevatedButton(
            onPressed: () =>
                context.read<AnalysisListCubit>().loadAnalyses(refresh: true),
            child: Text(context.translate.retry),
          ),
        ],
      ),
    );
  }
}
