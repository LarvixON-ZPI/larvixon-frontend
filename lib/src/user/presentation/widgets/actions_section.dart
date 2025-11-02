import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: IconButton(
        tooltip: context.translate.back,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AnalysesOverviewPage.route);
          }
        },
        icon: const Icon(FontAwesomeIcons.arrowLeft),
      ),
    );
  }
}
