import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/background.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Center(
            child: CustomCard(
              constraints: kDefaultPageWidthConstraitns,
              icon: Icon(
                Icons.error_outline,
                size: 60,
                color: theme.colorScheme.error,
              ),
              title: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "404 "),
                    TextSpan(text: context.translate.notFound_title),
                  ],
                ),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              description: Text(
                context.translate.notFound_description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              child: FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
                label: Text(context.translate.back),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
