import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analysis_add_dialog.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/sort_popup_menu.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/icon_text_button.dart';
import 'package:larvixon_frontend/src/common/widgets/side_bar_base.dart';

class AnalysesSidebar extends StatelessWidget {
  const AnalysesSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SideBarBase(
      children: [_UploadButton(), _SortSelector(), _FilterButton()],
    );
  }
}

class _UploadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconTextButton(
      icon: FontAwesomeIcons.circlePlus,
      text: context.translate.upload,
      onPressed: () async {
        await LarvaVideoAddForm.showUploadLarvaVideoDialog(
          context,
          context.read<AnalysisListCubit>(),
        );
      },
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

class _FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconTextButton(
      icon: FontAwesomeIcons.filter,
      text: context.translate.filter,
      onPressed: () {
        // TODO: implement filter dialog
      },
    );
  }
}
