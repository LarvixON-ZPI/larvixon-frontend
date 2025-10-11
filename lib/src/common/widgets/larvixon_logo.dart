// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class LarvixonLogo extends StatelessWidget {
  final VoidCallback? onPressed;
  const LarvixonLogo({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        context.translate.larvixon,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
