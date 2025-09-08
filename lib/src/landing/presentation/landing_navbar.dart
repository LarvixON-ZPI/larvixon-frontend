import 'package:flutter/material.dart';

import '../../common/extensions/translate_extension.dart';

class LandingNavBar extends StatelessWidget {
  const LandingNavBar({
    super.key,
    this.onAboutPressed,
    this.onContactPressed,
    this.onSignInPressed,
    this.onLogoPressed,
  });
  final VoidCallback? onAboutPressed;
  final VoidCallback? onContactPressed;
  final VoidCallback? onSignInPressed;
  final VoidCallback? onLogoPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Expanded(
            child: Text(
              context.translate.larvixon,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),

          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onAboutPressed,
                  child: Text(
                    context.translate.about,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: onContactPressed,
                  child: Text(
                    context.translate.contact,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onSignInPressed,
                  child: Text(
                    context.translate.signIn,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
