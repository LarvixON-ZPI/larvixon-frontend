import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_dropdown_menu.dart';

import '../extensions/translate_extension.dart';

class Footer extends StatelessWidget {
  final VoidCallback? onPrivacyPressed;
  final VoidCallback? onTermsPressed;

  const Footer({super.key, this.onPrivacyPressed, this.onTermsPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Wrap(
        spacing: 8,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('© 2025 ${context.translate.larvixon}'),
          TextButton(
            onPressed: onPrivacyPressed,
            child: Text(context.translate.privacy),
          ),
          TextButton(
            onPressed: onTermsPressed,
            child: Text(context.translate.terms),
          ),
          LocaleDropdownMenu(),
        ],
      ),
    );
  }
}
