// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/about_us/domain/entities/team_member.dart';
import 'package:larvixon_frontend/src/about_us/presentation/widgets/team_member_details.dart';
import 'package:larvixon_frontend/src/common/extensions/default_padding.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';

class TeamMemberAvatar extends StatelessWidget {
  final TeamMember teamMember;
  const TeamMemberAvatar({
    super.key,
    required this.teamMember,
    this.size = 120,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = teamMember.imageUrl;
    final bool hasImage = imageUrl != null;
    return GestureDetector(
      onTap: () => showGeneralDialog(
        context: context,
        barrierLabel: "Team Member",
        barrierDismissible: true,
        pageBuilder: (_, _, _) => const SizedBox.shrink(),
        transitionBuilder: (context, anim, _, __) {
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
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: size, maxWidth: size),
        child: Column(
          spacing: 4,
          children: [
            CircleAvatar(
              radius: size / 2,
              backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
              child: hasImage
                  ? null
                  : Icon(Icons.person, size: size / 2, color: Colors.grey),
            ).withOnHoverEffect,
            Text("${teamMember.name} ${teamMember.surname}"),
          ],
        ),
      ),
    );
  }
}
