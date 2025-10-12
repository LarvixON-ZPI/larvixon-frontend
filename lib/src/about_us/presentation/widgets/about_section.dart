import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/about_us/presentation/widgets/team_members_card.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

import '../../../common/extensions/translate_extension.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.translate.about,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.translate.aboutDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),

        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < Breakpoints.small;
            return IntrinsicHeight(
              child: Flex(
                direction: isNarrow ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: SizedBox(
                      width: isNarrow ? double.infinity : null,
                      child: CustomCard(
                        icon: Icon(Icons.flag),
                        title: Text(
                          context.translate.ourMission,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        description: Text(
                          context.translate.ourMissionDescription,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: SizedBox(
                      width: isNarrow ? double.infinity : null,
                      child: CustomCard(
                        icon: Icon(Icons.lightbulb),
                        title: Text(
                          context.translate.ourVision,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        description: Text(
                          context.translate.ourVisionDescription,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(width: double.infinity, child: TeamMembersCard()),
      ],
    );
  }
}
