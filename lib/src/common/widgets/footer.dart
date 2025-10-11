import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_dropdown_menu.dart';

import '../extensions/translate_extension.dart';

class Footer extends StatelessWidget {
  final VoidCallback? onPrivacyPressed;
  final VoidCallback? onTermsPressed;

  const Footer({super.key, this.onPrivacyPressed, this.onTermsPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use Row for wider screens, Wrap for narrow screens
          if (constraints.maxWidth > 600) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '© 2025 ${context.translate.larvixon}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: onPrivacyPressed,
                      child: Text(context.translate.privacy),
                    ),
                    TextButton(
                      onPressed: onTermsPressed,
                      child: Text(context.translate.terms),
                    ),
                    IntrinsicWidth(child: LocaleDropdownMenu()),
                  ],
                ),
              ],
            );
          } else {
            // Wrap for narrow screens
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center, // Fixed this
              children: [
                Text(
                  '© 2025 ${context.translate.larvixon}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
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
            );
          }
        },
      ),
    );
  }
}
