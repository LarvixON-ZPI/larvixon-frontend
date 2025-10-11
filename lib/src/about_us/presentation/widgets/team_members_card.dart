import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/about_us/domain/entities/team_member.dart';
import 'package:larvixon_frontend/src/about_us/presentation/widgets/team_member_avatar.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class TeamMembersCard extends StatelessWidget {
  const TeamMembersCard({super.key});
  static const TeamMember jantar = TeamMember(
    name: "Mikołaj",
    surname: "Kubś",
    roles: [MemberRole.backend, MemberRole.frontend, MemberRole.simulation],
  );
  static const TeamMember margarynka = TeamMember(
    name: "Martyna",
    surname: "Łopianiak",
    roles: [MemberRole.backend],
  );
  static const TeamMember krzysztof = TeamMember(
    name: "Krzysztof",
    surname: "Kulka",
    roles: [MemberRole.ml],
  );
  static const TeamMember patryk = TeamMember(
    name: "Patryk",
    surname: "Łuszczek",
    roles: [MemberRole.frontend, MemberRole.ui, MemberRole.ux],
  );

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      icon: Icon(Icons.group),
      title: Text(
        context.translate.ourTeam,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      child: SizedBox(
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
