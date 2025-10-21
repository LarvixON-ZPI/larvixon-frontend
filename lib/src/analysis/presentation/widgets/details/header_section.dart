import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key, required this.analysis});

  final Analysis analysis;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        children: [
          Text(
            "${context.translate.analysis} #${analysis.id}",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.fileExport,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.xmark,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
