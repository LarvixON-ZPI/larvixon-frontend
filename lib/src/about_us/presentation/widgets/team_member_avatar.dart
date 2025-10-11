import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/about_us/domain/entities/team_member.dart';
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
    final String? rolesText = teamMember.rolesString;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: size, maxWidth: size),
      child: Column(
        spacing: 4,
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundImage: hasImage ? NetworkImage(imageUrl) : null,
            backgroundColor: Colors.grey[200],
            child: hasImage
                ? null
                : Icon(Icons.person, size: size / 2, color: Colors.grey),
          ).withOnHoverEffect,
          Text("${teamMember.name} ${teamMember.surname}"),
          if (rolesText != null)
            Text(
              rolesText,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
