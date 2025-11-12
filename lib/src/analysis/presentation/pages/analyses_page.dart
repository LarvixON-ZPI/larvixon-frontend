import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analyses/analyses_list.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analyses/analyses_sidebar.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analyses/empty_view.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analyses/loading_view.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/error_view.dart';

class AnalysesOverviewPage extends StatefulWidget {
  const AnalysesOverviewPage({super.key});
  static const String route = '/analyses';
  static const String name = 'analyses-overview';

  @override
  State<AnalysesOverviewPage> createState() => _AnalysesOverviewPageState();
}

class _AnalysesOverviewPageState extends State<AnalysesOverviewPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<AnalysisListCubit>();
      if (cubit.state.isEmpty) {
        cubit.loadAnalyses();
      }
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
    super.build(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: AnalysesSidebar(),
        ),
        Expanded(child: _AnalysesContent(scrollController: _scrollController)),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _AnalysesContent extends StatelessWidget {
  final ScrollController scrollController;
  const _AnalysesContent({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisListCubit, AnalysisListState>(
      builder: (context, state) {
        if (state.isLoading) return const LoadingView();
        if (state.isError) return ErrorView(errorMessage: state.errorMessage!);
        if (state.isEmpty) return const EmptyView();
        return AnalysesList(
          scrollController: scrollController,
          analysesIds: state.analysesIds,
        );
      },
    );
  }
}

extension on AnalysisListState {
  bool get isEmpty => errorMessage == null && analysesIds.isEmpty;
  bool get isError => errorMessage != null && analysesIds.isEmpty;
  bool get isLoading =>
      status == AnalysisListStatus.loading && analysesIds.isEmpty;
}
