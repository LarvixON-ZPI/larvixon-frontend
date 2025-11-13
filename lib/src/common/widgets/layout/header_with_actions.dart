import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/action_section_base.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_section_base.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/action_item.dart';

class HeaderWithActions extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? fallbackRoute;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<ActionItem> actions;
  final int? maxVisibleActions;
  final List<int>? alwaysVisibleActionIndices;
  final bool showActionLabels;
  final double compactBreakpoint;

  const HeaderWithActions({
    super.key,
    required this.title,
    this.subtitle,
    this.fallbackRoute,
    this.showBackButton = true,
    this.onBack,
    required this.actions,
    this.maxVisibleActions,
    this.alwaysVisibleActionIndices,
    this.showActionLabels = false,
    this.compactBreakpoint = Breakpoints.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HeaderSectionBase(
            title: title,
            subtitle: subtitle,
            fallbackRoute: fallbackRoute,
            showBackButton: showBackButton,
            onBack: onBack,
          ),
        ),
        if (actions.isNotEmpty)
          ActionsSection(
            actions: actions,
            maxVisibleActions: maxVisibleActions,
            alwaysVisibleIndices: alwaysVisibleActionIndices,
            showLabels: showActionLabels,
            compactBreakpoint: compactBreakpoint,
          ),
      ],
    );
  }
}
