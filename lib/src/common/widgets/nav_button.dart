import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavButton extends StatelessWidget {
  final String route;
  final IconData icon;
  final String label;

  const NavButton({
    super.key,
    required this.route,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouter.of(context).state.matchedLocation;
    final isSelected = currentRoute == route;

    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.iconTheme.color;
    return TextButton.icon(
      onPressed: isSelected ? null : () => context.go(route),
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: theme.colorScheme.primary.withOpacity(0.6),
      ),
    );
  }
}
