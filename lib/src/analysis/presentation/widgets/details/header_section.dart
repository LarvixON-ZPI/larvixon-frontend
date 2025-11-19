import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/core/constants/endpoints_report.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/common/extensions/navigation_extensions.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/services/file_download/file_download_service.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_with_actions.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/action_item.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required this.analysis,
    this.enableActions = true,
  });

  final Analysis analysis;
  final bool enableActions;

  @override
  Widget build(BuildContext context) {
    return HeaderWithActions(
      title: "${context.translate.analysis} #${analysis.id}",
      fallbackRoute: AnalysesOverviewPage.route,
      actions: enableActions
          ? [
              if (analysis.status == AnalysisProgressStatus.completed)
                ActionItem.export(
                  label: context.translate.export,
                  onPressed: () => _downloadAnalysisReport(context),
                ),
              if (analysis.status == AnalysisProgressStatus.failed)
                ActionItem(
                  icon: const Icon(FontAwesomeIcons.arrowsRotate),
                  label: context.translate.retry,
                  onPressed: () => _onRetryPressed(context),
                ),
              ActionItem(
                label: context.translate.delete,
                icon: const Icon(FontAwesomeIcons.trash),
                onPressed: () => _onDeletePressed(context),
              ),
            ]
          : [],
    );
  }

  void _downloadAnalysisReport(BuildContext context) async {
    try {
      final downloader = FileDownloadService(context.read());
      await downloader.downloadFile(
        url: ReportEndpoints.reportPdfByAnalysisId(analysis.id),
        fileName: "analysis_${analysis.id}_report.pdf",
      );
    } catch (e) {
      _showDownloadErrorDialog(context, e);
    }
  }

  void _onRetryPressed(BuildContext context) {
    final bloc = context.read<AnalysisBloc>();
    bloc.add(RetryAnalysis(analysisId: analysis.id));
  }

  Future<Object?> _showDownloadErrorDialog(BuildContext context, Object e) {
    return showGeneralDialog(
      barrierDismissible: true,
      context: context,
      barrierLabel: "Download failed",
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: CustomCard(
                title: Text(
                  context.translate.error,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                description: Text(
                  e.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => context.popMaybe(),
                  child: const Text("Ok"),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onDeletePressed(BuildContext context) {
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
                if (state.status == AnalysisStatus.deleted) context.popMaybe();
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
                      analysis.name ??
                          "${context.translate.analysis} #${analysis.id}",
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  child: Row(
                    spacing: 16,
                    children: [
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () => context.popMaybe(),
                          icon: const Icon(FontAwesomeIcons.xmark),
                          label: Text(
                            context.translate.cancel,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
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
                          icon: const Icon(FontAwesomeIcons.trash),
                          label: Text(
                            context.translate.confirmDelete,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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
