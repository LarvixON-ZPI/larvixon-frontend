import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/actions/action_button_data.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key, required this.analysis});

  final Analysis analysis;
  List<ActionButtonData> getActions(BuildContext context) {
    return [
      ActionButtonData(
        label: context.translate.delete,
        icon: const Icon(FontAwesomeIcons.trash),
        color: Colors.red,
        onPressed: () => onDeletePressed(context),
      ),
      ActionButtonData(
        label: context.translate.export,
        icon: const Icon(FontAwesomeIcons.fileExport),
        onPressed: () {
          // TODO
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < Breakpoints.medium;
    final List<ActionButtonData> actions = getActions(context);
    if (isCompact) {
      return CustomCard(
        child: PopupMenuButton(
          icon: const Icon(FontAwesomeIcons.bars),
          offset: const Offset(0, 40),
          itemBuilder: (context) {
            return actions.map((a) {
              return PopupMenuItem(
                onTap: a.onPressed,
                child: Row(
                  spacing: 8,
                  children: [a.icon, if (a.label != null) Text(a.label!)],
                ),
              );
            }).toList();
          },
        ),
      );
    }
    return Row(
      children: actions.map((a) {
        return CustomCard(
          child: IconButton(
            onPressed: a.onPressed,
            icon: a.icon,
            tooltip: a.label,
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(a.color),
            ),
          ),
        );
      }).toList(),
    );
  }

  void onDeletePressed(BuildContext context) {
    final bloc = context.read<AnalysisBloc>();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Delete Dialog",
      barrierColor: Colors.black54,
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            child: BlocConsumer<AnalysisBloc, AnalysisState>(
              listener: (BuildContext context, AnalysisState state) {
                if (state.status == AnalysisStatus.deleted) {
                  if (context.canPop()) {
                    context.pop();
                  }
                }
              },

              bloc: bloc,
              builder: (context, state) {
                return CustomCard(
                  constraints: const BoxConstraints(maxWidth: 600),
                  title: Text(
                    textAlign: TextAlign.left,
                    context.translate.confirmDelete,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  description: Text(
                    context.translate.confirmDeleteAnalysisText(
                      "${context.translate.analysis} #${analysis.id}",
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  child: Row(
                    spacing: 16,
                    children: [
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () => context.pop(),
                          icon: const Icon(FontAwesomeIcons.xmark),
                          label: Text(
                            context.translate.cancel,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            bloc.add(RemoveAnalysis(analysisId: analysis.id));
                          },
                          icon: const Icon(FontAwesomeIcons.check),
                          label: Text(
                            context.translate.confirm,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
