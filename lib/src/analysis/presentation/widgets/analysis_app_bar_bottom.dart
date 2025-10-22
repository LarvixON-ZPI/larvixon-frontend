import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analysis_add_dialog.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/sort_popup_menu.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/app_bar_bottom_base.dart';
import 'package:larvixon_frontend/src/common/widgets/icon_text_button.dart';

class AnalysisAppBarBottom extends StatelessWidget
    implements PreferredSizeWidget {
  const AnalysisAppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarBottomBase(
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
          mainAxisAlignment: MainAxisAlignment.center,
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
        ),
        Column(
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
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56);
}
