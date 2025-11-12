import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/about_us/presentation/widgets/team_members_card.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomCard(
          title: Text(
            context.translate.about,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          description: Text(
            context.translate.aboutDescription,
            style: Theme.of(context).textTheme.bodyLarge,
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
                        icon: const Icon(Icons.flag),
                        title: Text(
                          context.translate.ourMission,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        description: Text(
                          context.translate.ourMissionDescription,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: SizedBox(
                      width: isNarrow ? double.infinity : null,
                      child: CustomCard(
                        icon: const Icon(Icons.lightbulb),
                        title: Text(
                          context.translate.ourVision,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        description: Text(
                          context.translate.ourVisionDescription,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: double.infinity, child: TeamMembersCard()),
      ],
    );
  }
}
