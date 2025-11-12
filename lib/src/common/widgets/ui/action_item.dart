import 'package:flutter/material.dart';

class ActionItem {
  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool requiresConfirmation;
  final ConfirmationConfig? confirmationConfig;

  const ActionItem({
    required this.label,
    required this.icon,
    this.onPressed,
    this.color,
    this.requiresConfirmation = false,
    this.confirmationConfig,
  });
  factory ActionItem.delete({
    required String label,
    required VoidCallback onConfirm,
    required String confirmTitle,
    required String confirmMessage,
    String? confirmButtonText,
    Color color = Colors.red,
  }) {
    return ActionItem(
      label: label,
      icon: const Icon(Icons.delete),
      color: color,
      requiresConfirmation: true,
      confirmationConfig: ConfirmationConfig(
        title: confirmTitle,
        message: confirmMessage,
        confirmButtonText: confirmButtonText ?? label,
        onConfirm: onConfirm,
      ),
    );
  }
  factory ActionItem.export({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ActionItem(
      label: label,
      icon: const Icon(Icons.file_download),
      onPressed: onPressed,
    );
  }
  factory ActionItem.edit({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ActionItem(
      label: label,
      icon: const Icon(Icons.edit),
      onPressed: onPressed,
    );
  }
  factory ActionItem.share({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ActionItem(
      label: label,
      icon: const Icon(Icons.share),
      onPressed: onPressed,
    );
  }
}

class ConfirmationConfig {
  final String title;
  final String message;
  final String confirmButtonText;
  final String? cancelButtonText;
  final VoidCallback onConfirm;
  final Color confirmButtonColor;

  const ConfirmationConfig({
    required this.title,
    required this.message,
    required this.confirmButtonText,
    this.cancelButtonText,
    required this.onConfirm,
    this.confirmButtonColor = Colors.red,
  });
}
