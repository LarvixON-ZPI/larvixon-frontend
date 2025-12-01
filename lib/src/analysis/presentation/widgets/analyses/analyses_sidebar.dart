import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_filter.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analysis_create_page.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analyses/filter_popup_menu.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analyses/sort_popup_menu.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/icon_text_button.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/side_bar_base.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/settings_dropdown_menu.dart';

class AnalysesSidebar extends StatelessWidget {
  const AnalysesSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SideBarBase(
      bottomChild: const SettingsDropdownMenu(offest: Offset(40, -50)),
      children: [_UploadButton(), _SortSelector(), _FilterSelector()],
    );
  }
}

class _UploadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconTextButton(
      icon: FontAwesomeIcons.circlePlus,
      text: context.translate.upload,
      onPressed: () => {context.push(AnalysisCreatePage.fullRoute)},
    );
  }
}

class _SortSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<AnalysisListCubit, AnalysisListState, AnalysisSort>(
          selector: (state) => state.sort,
          builder: (context, sort) => SortPopupMenu(initialSorting: sort),
        ),
        Text(
          context.translate.sort,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _FilterSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<AnalysisListCubit, AnalysisListState, AnalysisFilter>(
          selector: (state) => state.filter,
          builder: (context, filter) =>
              FilterPopupMenu(initialFiltering: filter),
        ),
        Text(
          context.translate.filter,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
