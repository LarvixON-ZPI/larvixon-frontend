import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

class SortPopupMenu extends StatelessWidget {
  final AnalysisSort initialSorting;
  const SortPopupMenu({super.key, required this.initialSorting});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      offset: const Offset(40, 0),
      child: Icon(
        FontAwesomeIcons.sort,
        color: Theme.of(context).iconTheme.color!,
      ),
      itemBuilder: (context) {
        AnalysisSortField tempField = initialSorting.field;
        SortOrder tempOrder = initialSorting.order;

        return [
          PopupMenuItem<int>(
            enabled: false,
            child: StatefulBuilder(
              builder: (context, setPopupState) => Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 4.0,
                runSpacing: 4.0,
                children: AnalysisSortField.values.map((f) {
                  return ChoiceChip(
                    showCheckmark: false,
                    selected: f == tempField,
                    onSelected: (s) {
                      if (s) setPopupState(() => tempField = f);
                    },
                    label: Text(f.translate(context)),
                  );
                }).toList(),
              ),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<int>(
            enabled: false,
            child: StatefulBuilder(
              builder: (context, setPopupState) => SegmentedButton<SortOrder>(
                expandedInsets: EdgeInsets.zero,
                showSelectedIcon: false,
                segments: SortOrder.values.map((o) {
                  return ButtonSegment<SortOrder>(
                    value: o,
                    label: Icon(o.icon),
                  );
                }).toList(),
                selected: {tempOrder},
                onSelectionChanged: (newSelection) {
                  setPopupState(() {
                    tempOrder = newSelection.first;
                  });
                },
              ),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<int>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: context.translate.close,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                IconButton(
                  tooltip: context.translate.reset,
                  onPressed: () {
                    context.read<AnalysisListCubit>().updateSort(
                      const AnalysisSort.defaultSorting(),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.restart_alt),
                ),
                IconButton(
                  tooltip: context.translate.apply,
                  onPressed: () {
                    context.read<AnalysisListCubit>().updateSort(
                      AnalysisSort(field: tempField, order: tempOrder),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
