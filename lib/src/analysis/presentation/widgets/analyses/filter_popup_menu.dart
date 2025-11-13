import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_filter.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/analyses/sort_popup_menu.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/date_range_input.dart';

class FilterPopupMenu extends StatelessWidget {
  final AnalysisFilter initialFiltering;
  const FilterPopupMenu({super.key, required this.initialFiltering});
  AnalysisProgressStatus? get initialStatus => initialFiltering.status;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: '',
      offset: const Offset(40, 0),
      child: Icon(
        FontAwesomeIcons.filter,
        color: Theme.of(context).iconTheme.color!,
      ),
      itemBuilder: (context) {
        AnalysisProgressStatus? selectedStatus = initialStatus;
        DateTimeRange? selectedDateRange = initialFiltering.createAtDateRange;
        DateTime? selectedStartDate = selectedDateRange?.start;
        DateTime? selectedEndDate = selectedDateRange?.end;

        return [
          PopupMenuItem(
            enabled: false,
            child: Wrap(
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      spacing: 4.0,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.translate.status,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            ...AnalysisProgressStatus.values.map((status) {
                              final isSelected = status == selectedStatus;
                              return ChoiceChip(
                                label: Text(status.displayName(context)),
                                showCheckmark: false,
                                selectedColor: status.color,
                                selectedShadowColor: status.color,

                                onSelected: (selectedNow) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedStatus = null;
                                    } else if (selectedNow) {
                                      selectedStatus = status;
                                    }
                                  });
                                },
                                selected: isSelected,
                              );
                            }),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            child: DateRangeInput(
              initialStart: selectedStartDate,
              initialEnd: selectedEndDate,
              onChanged: (start, end) {
                final effectiveStart = start ?? DateTime(2000);
                final effectiveEnd = end ?? DateTime.now();

                selectedStartDate = effectiveStart;
                selectedEndDate = effectiveEnd;

                if (effectiveStart.isAfter(effectiveEnd)) {
                  selectedDateRange = DateTimeRange(
                    start: effectiveEnd,
                    end: effectiveStart,
                  );
                } else {
                  selectedDateRange = DateTimeRange(
                    start: effectiveStart,
                    end: effectiveEnd,
                  );
                }
              },
            ),
          ),
          const PopupMenuDivider(),

          PopupMenuItem(
            child: PopupControlsRow(
              onClose: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              onApply: () {
                final filter = AnalysisFilter(
                  status: selectedStatus,
                  createAtDateRange: selectedDateRange,
                );
                context.read<AnalysisListCubit>().updateFilter(filter);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              onReset: () {
                context.read<AnalysisListCubit>().resetFilter();
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ];
      },
    );
  }
}
