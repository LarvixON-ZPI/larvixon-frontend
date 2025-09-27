import 'package:flutter/material.dart';

import '../extensions/translate_extension.dart';

class Footer extends StatelessWidget {
  final VoidCallback? onPrivacyPressed;
  final VoidCallback? onTermsPressed;

  const Footer({super.key, this.onPrivacyPressed, this.onTermsPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Row(
        spacing: 8,
        children: [
          Text(
            '© 2025 ${context.translate.larvixon}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          TextButton(
            onPressed: onPrivacyPressed,
            child: Text(context.translate.privacy),
          ),
          TextButton(
            onPressed: onTermsPressed,
            child: Text(context.translate.terms),
          ),
        ],
      ),
    );
  }
}
