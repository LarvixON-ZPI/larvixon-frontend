import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key, required this.analysis});

  final Analysis analysis;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        spacing: 16.0,
        children: [
          IconButton(
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
          Text(
            "${context.translate.analysis} #${analysis.id}",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
