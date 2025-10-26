import 'package:flutter/material.dart';

@immutable
class ActionButtonData {
  final VoidCallback? onPressed;
  final Icon icon;
  final String? label;
  final Color? color;

  const ActionButtonData({
    required this.icon,
    this.onPressed,
    this.label,
    this.color,
  });
}
