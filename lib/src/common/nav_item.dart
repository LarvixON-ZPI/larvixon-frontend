import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final IconData icon;
  final String route;
  final VoidCallback? onTap;

  const NavItem({
    required this.label,
    required this.icon,
    required this.route,
    this.onTap,
  });
}
