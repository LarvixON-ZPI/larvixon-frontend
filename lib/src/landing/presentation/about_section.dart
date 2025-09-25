import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

import '../../common/extensions/translate_extension.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translate.about,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          context.translate.aboutDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        // TODO: make the cards expand to full width on narrow
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < Breakpoints.small;
            return Flex(
              direction: isNarrow ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Expanded(
                  flex: isNarrow ? 0 : 1,
                  child: CustomCard(
                    icon: Icons.flag,
                    title: context.translate.ourMission,
                    description: context.translate.ourMissionDescription,
                  ),
                ),

                Expanded(
                  flex: isNarrow ? 0 : 1,
                  child: CustomCard(
                    icon: Icons.lightbulb,
                    title: context.translate.ourVision,
                    description: context.translate.ourVisionDescription,
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(
          width: double.infinity,
          child: CustomCard(
            icon: Icons.group,
            title: context.translate.ourTeam,
            children: [
              _TeamMemberAvatar(name: "Mikołaj Kubś").withOnHoverEffect,
              _TeamMemberAvatar(name: "Martyna Łopianiak").withOnHoverEffect,
              _TeamMemberAvatar(name: "Krzysztof Kulka").withOnHoverEffect,
              _TeamMemberAvatar(name: "Patryk Łuszczek").withOnHoverEffect,
            ],
          ),
        ),
      ],
    );
  }
}

class _TeamMemberAvatar extends StatelessWidget {
  const _TeamMemberAvatar({
    super.key,
    required this.name,
    this.image,
    this.size = 120,
    this.role,
  });

  final Image? image;
  final double size; // allows different avatar sizes
  final String name;
  final String? role;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundImage: image?.image,
          backgroundColor: Colors.grey[200], // fallback background
          child: image == null
              ? Icon(Icons.person, size: size / 2, color: Colors.grey)
              : null,
        ),
        Text(name),
        if (role != null) Text(role!),
      ],
    );
  }
}
