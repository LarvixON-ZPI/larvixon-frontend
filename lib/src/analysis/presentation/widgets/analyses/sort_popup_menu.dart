import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_field_enum.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_sort.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/sort_order.dart';

class SortPopupMenu extends StatelessWidget {
  final AnalysisSort initialSorting;
  const SortPopupMenu({super.key, required this.initialSorting});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: '',
      offset: const Offset(40, 0),
      child: AnimatedRotation(
        turns: initialSorting.order == SortOrder.ascending ? 0.0 : 0.5,
        duration: const Duration(milliseconds: 300),
        child: Icon(
          FontAwesomeIcons.sortUp,
          color: Theme.of(context).iconTheme.color!,
        ),
      ),
      itemBuilder: (context) {
        AnalysisField tempField = initialSorting.field;
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
                children: AnalysisField.values.map((f) {
                  return ChoiceChip(
                    showCheckmark: false,
                    selected: f == tempField,
                    onSelected: (s) {
                      if (s) setPopupState(() => tempField = f);
                    },
                    label: Text(f.displayName(context)),
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
          PopupMenuItem(
            child: PopupControlsRow(
              onClose: () => Navigator.pop(context),
              onReset: () {
                context.read<AnalysisListCubit>().updateSort(
                  const AnalysisSort.defaultSorting(),
                );
                Navigator.pop(context);
              },
              onApply: () {
                context.read<AnalysisListCubit>().updateSort(
                  AnalysisSort(field: tempField, order: tempOrder),
                );
                Navigator.pop(context);
              },
            ),
          ),
        ];
      },
    );
  }
}

class PopupControlsRow extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onReset;
  final VoidCallback? onApply;
  const PopupControlsRow({super.key, this.onClose, this.onReset, this.onApply});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onClose != null)
          IconButton(
            tooltip: context.translate.close,
            onPressed: onClose,
            icon: const Icon(Icons.close),
          ),
        if (onReset != null)
          IconButton(
            tooltip: context.translate.reset,
            onPressed: onReset,
            icon: const Icon(Icons.restart_alt),
          ),
        if (onApply != null)
          IconButton(
            tooltip: context.translate.apply,
            onPressed: onApply,
            icon: const Icon(Icons.check),
          ),
      ],
    );
  }
}
