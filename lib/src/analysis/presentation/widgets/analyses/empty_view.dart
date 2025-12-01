import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analysis_create_page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

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
          onPressed: () => {context.push(AnalysisCreatePage.fullRoute)},
          child: Text(context.translate.clickToUpload),
        ),
      ),
    );
  }
}
