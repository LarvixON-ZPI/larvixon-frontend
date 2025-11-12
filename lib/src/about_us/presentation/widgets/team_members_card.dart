import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/about_us/domain/entities/team_member.dart';
import 'package:larvixon_frontend/src/about_us/presentation/widgets/team_member_details.dart';
import 'package:larvixon_frontend/src/common/extensions/default_padding.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/profile_avatar.dart';

class TeamMembersCard extends StatelessWidget {
  const TeamMembersCard({super.key});
  static const List<TeamMember> teamMembers = [
    jantar,
    margarynka,
    krzysztof,
    patryk,
  ];

  Future<Object?> onAvatarTap(TeamMember teamMember, BuildContext context) =>
      showGeneralDialog(
        context: context,
        barrierLabel: "Team Member",
        barrierDismissible: true,
        pageBuilder: (_, _, _) => const SizedBox.shrink(),
        transitionBuilder: (context, anim, _, _) {
          return FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TeamMemberDetails(teamMember: teamMember),
                  ),
                ).withDefaultPagePadding,
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      icon: const Icon(Icons.group),
      title: Text(
        context.translate.ourTeam,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: teamMembers
              .map(
                (member) => Column(
                  spacing: 6,
                  children: [
                    ProfileAvatar(
                      imageUrl: member.imageUrl,
                      size: 60,
                      onTap: () => onAvatarTap(member, context),
                    ),
                    Text("${member.name} ${member.surname}"),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
