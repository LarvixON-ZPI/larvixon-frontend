import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/constants/breakpoints.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/action_item.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class ActionsSection extends StatelessWidget {
  final List<ActionItem> actions;
  final double compactBreakpoint;
  final bool showLabels;
  final int? maxVisibleActions;
  final List<int>? alwaysVisibleIndices;

  const ActionsSection({
    super.key,
    required this.actions,
    this.compactBreakpoint = Breakpoints.medium,
    this.showLabels = false,
    this.maxVisibleActions,
    this.alwaysVisibleIndices,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    final isCompact = MediaQuery.of(context).size.width < compactBreakpoint;

    if (isCompact) {
      return _CompactActionsMenu(actions: actions);
    }

    final shouldUseOverflow =
        maxVisibleActions != null && actions.length > maxVisibleActions!;

    if (shouldUseOverflow) {
      return _ActionsWithOverflow(
        actions: actions,
        maxVisibleActions: maxVisibleActions!,
        alwaysVisibleIndices: alwaysVisibleIndices,
        showLabels: showLabels,
      );
    }

    return _ExpandedActionsButtons(actions: actions, showLabels: showLabels);
  }
}

class _ExpandedActionsButtons extends StatelessWidget {
  final List<ActionItem> actions;
  final bool showLabels;

  const _ExpandedActionsButtons({
    required this.actions,
    required this.showLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: actions.map((action) {
        return _ActionButton(action: action, showLabel: showLabels);
      }).toList(),
    );
  }
}

class _ActionsWithOverflow extends StatelessWidget {
  final List<ActionItem> actions;
  final int maxVisibleActions;
  final List<int>? alwaysVisibleIndices;
  final bool showLabels;

  const _ActionsWithOverflow({
    required this.actions,
    required this.maxVisibleActions,
    this.alwaysVisibleIndices,
    required this.showLabels,
  });

  @override
  Widget build(BuildContext context) {
    final visibleActions = <ActionItem>[];
    final overflowActions = <ActionItem>[];

    for (int i = 0; i < actions.length; i++) {
      final alwaysVisible = alwaysVisibleIndices?.contains(i) ?? false;

      if (alwaysVisible || visibleActions.length < maxVisibleActions) {
        visibleActions.add(actions[i]);
      } else {
        overflowActions.add(actions[i]);
      }
    }

    return Row(
      spacing: 2,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...visibleActions.map(
          (action) => _ActionButton(action: action, showLabel: showLabels),
        ),
        if (overflowActions.isNotEmpty)
          _OverflowActionsMenu(actions: overflowActions),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final ActionItem action;
  final bool showLabel;

  const _ActionButton({required this.action, required this.showLabel});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: showLabel
          ? TextButton.icon(
              onPressed: action.requiresConfirmation
                  ? () => _showConfirmationDialog(context)
                  : action.onPressed,
              icon: action.icon,
              label: Text(action.label),
              style: TextButton.styleFrom(foregroundColor: action.color),
            )
          : IconButton(
              onPressed: action.requiresConfirmation
                  ? () => _showConfirmationDialog(context)
                  : action.onPressed,
              icon: action.icon,
              tooltip: action.label,
              style: IconButton.styleFrom(foregroundColor: action.color),
            ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    _ActionConfirmationDialog.show(context, action);
  }
}

class _OverflowActionsMenu extends StatelessWidget {
  final List<ActionItem> actions;

  const _OverflowActionsMenu({required this.actions});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: PopupMenuButton(
        icon: const Icon(Icons.more_horiz),
        offset: const Offset(0, 40),
        itemBuilder: (context) => actions.map((action) {
          return PopupMenuItem(
            enabled: action.onPressed != null,
            onTap: action.requiresConfirmation ? null : action.onPressed,
            child: _PopupActionItem(action: action),
          );
        }).toList(),
      ),
    );
  }
}

class _CompactActionsMenu extends StatelessWidget {
  final List<ActionItem> actions;

  const _CompactActionsMenu({required this.actions});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        offset: const Offset(0, 40),
        itemBuilder: (context) => actions.map((action) {
          return PopupMenuItem(
            enabled: action.onPressed != null,
            onTap: action.requiresConfirmation ? null : action.onPressed,
            child: _PopupActionItem(action: action),
          );
        }).toList(),
      ),
    );
  }
}

class _PopupActionItem extends StatelessWidget {
  final ActionItem action;

  const _PopupActionItem({required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action.requiresConfirmation
          ? () {
              context.pop();
              _ActionConfirmationDialog.show(context, action);
            }
          : null,
      child: Row(
        spacing: 12,
        children: [
          IconTheme(
            data: IconThemeData(
              color: action.color ?? Theme.of(context).iconTheme.color,
              size: 18,
            ),
            child: action.icon,
          ),
          Expanded(
            child: Text(action.label, style: TextStyle(color: action.color)),
          ),
        ],
      ),
    );
  }
}

class _ActionConfirmationDialog extends StatelessWidget {
  final ActionItem action;

  const _ActionConfirmationDialog({required this.action});

  static void show(BuildContext context, ActionItem action) {
    if (action.confirmationConfig == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _ActionConfirmationDialog(action: action),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = action.confirmationConfig!;

    return AlertDialog(
      title: Text(config.title),
      content: Text(config.message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(config.cancelButtonText ?? context.translate.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            config.onConfirm();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: config.confirmButtonColor,
            foregroundColor: Colors.white,
          ),
          child: Text(config.confirmButtonText),
        ),
      ],
    );
  }
}
