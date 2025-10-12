import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/about_us/domain/entities/team_member.dart';
import 'package:larvixon_frontend/src/about_us/presentation/widgets/team_member_avatar.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class TeamMembersCard extends StatelessWidget {
  const TeamMembersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      icon: const Icon(Icons.group),
      title: Text(
        context.translate.ourTeam,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            TeamMemberAvatar(teamMember: jantar),
            TeamMemberAvatar(teamMember: margarynka),
            TeamMemberAvatar(teamMember: krzysztof),
            TeamMemberAvatar(teamMember: patryk),
          ],
        ),
      ),
    );
  }
}
