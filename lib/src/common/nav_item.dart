import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final IconData icon;
  final String route;
  final VoidCallback? onTap;
  final Object? extra;

  const NavItem({
    required this.label,
    required this.icon,
    required this.route,
    this.extra,
    this.onTap,
  });
}
