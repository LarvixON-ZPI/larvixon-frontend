import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/about_us/domain/entities/team_member.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMemberDetails extends StatefulWidget {
  final TeamMember teamMember;
  const TeamMemberDetails({super.key, required this.teamMember});

  @override
  State<TeamMemberDetails> createState() => _TeamMemberDetailsState();
}

class _TeamMemberDetailsState extends State<TeamMemberDetails>
    with TickerProviderStateMixin {
  late final List<AnimationController> _roleControllers;
  late final List<AnimationController> _linkControllers;

  late final List<Animation<Offset>> _roleSlideAnimations;
  late final List<Animation<double>> _roleFadeAnimations;

  late final List<Animation<Offset>> _linkSlideAnimations;
  late final List<Animation<double>> _linkFadeAnimations;

  @override
  void initState() {
    super.initState();

    final roles = widget.teamMember.roles ?? [];
    final links = widget.teamMember.links ?? [];

    _roleControllers = List.generate(
      roles.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _roleSlideAnimations = _roleControllers
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)),
        )
        .toList();

    _roleFadeAnimations = _roleControllers
        .map(
          (c) => CurvedAnimation(
            parent: c,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        )
        .toList();

    _linkControllers = List.generate(
      links.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _linkSlideAnimations = _linkControllers
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutBack)),
        )
        .toList();

    _linkFadeAnimations = _linkControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeIn))
        .toList();

    _playStaggeredAnimations();
  }

  Future<void> _playStaggeredAnimations() async {
    final roles = widget.teamMember.roles ?? [];
    final links = widget.teamMember.links ?? [];

    for (int i = 0; i < links.length; i++) {
      await Future.delayed(Duration(milliseconds: 80 * i));
      if (mounted) _linkControllers[i].forward();
    }
    for (int i = 0; i < roles.length; i++) {
      await Future.delayed(Duration(milliseconds: 100 * i));
      if (mounted) _roleControllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (var c in [..._roleControllers, ..._linkControllers]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamMember = widget.teamMember;
    final hasImage = teamMember.imageUrl != null;
    final hasRoles = teamMember.roles?.isNotEmpty ?? false;
    final hasLinks = teamMember.links?.isNotEmpty ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double avatarRadius = (constraints.maxWidth * 0.2).clamp(
          48.0,
          120,
        );

        return CustomCard(
          title: Text(
            "${teamMember.name} ${teamMember.surname}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          description: hasLinks
              ? Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(teamMember.links!.length, (i) {
                    final link = teamMember.links![i];
                    return FadeTransition(
                      opacity: _linkFadeAnimations[i],
                      child: SlideTransition(
                        position: _linkSlideAnimations[i],
                        child: IconButton(
                          icon: Icon(link.platform.icon),
                          tooltip: link.platform.toString(),
                          onPressed: () => launchUrl(Uri.parse(link.url)),
                        ),
                      ),
                    );
                  }),
                )
              : null,
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundImage: hasImage
                    ? NetworkImage(teamMember.imageUrl!)
                    : null,
                backgroundColor: Colors.grey[200],
                child: hasImage
                    ? null
                    : Icon(
                        Icons.person,
                        size: avatarRadius,
                        color: Colors.grey,
                      ),
              ).withOnHoverEffect,
              if (hasRoles)
                Expanded(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(teamMember.roles!.length, (i) {
                      final role = teamMember.roles![i];
                      return FadeTransition(
                        opacity: _roleFadeAnimations[i],
                        child: SlideTransition(
                          position: _roleSlideAnimations[i],
                          child: Chip(
                            label: Text(role.toString()),
                            elevation: 2,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ).withOnHoverEffect,
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
