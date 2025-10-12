// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:ui';

import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AppBarButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: Theme.of(context).iconTheme.color!),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
