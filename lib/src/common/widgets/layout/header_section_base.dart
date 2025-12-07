import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/my_back_button.dart';

class HeaderSectionBase extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? fallbackRoute;
  final bool showBackButton;
  final VoidCallback? onBack;
  const HeaderSectionBase({
    super.key,
    required this.title,
    this.subtitle,
    this.fallbackRoute = '/',
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        spacing: 8,
        children: [
          if (showBackButton)
            MyBackButton(fallbackRoute: fallbackRoute, onPressed: onBack),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                SelectableText(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: 1,
                ),
                if (subtitle != null)
                  SelectableText(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
