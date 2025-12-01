import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class StepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String? subtitle;
  final Widget child;
  final bool isCompleted;
  final bool isActive;
  final bool isOptional;

  const StepCard({
    super.key,
    required this.stepNumber,
    required this.title,
    this.subtitle,
    required this.child,
    this.isCompleted = false,
    this.isActive = true,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color iconBackgroundColor = isCompleted
        ? colorScheme.primary
        : isActive
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;

    final Color iconColor = isCompleted
        ? colorScheme.onPrimary
        : isActive
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    final Color titleColor = !isActive
        ? colorScheme.onSurface.withValues(alpha: 0.5)
        : colorScheme.onSurface;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: isCompleted
                        ? Icon(
                            Icons.check,
                            key: const ValueKey('check'),
                            color: iconColor,
                            size: 24,
                          )
                        : Text(
                            stepNumber.toString(),
                            key: ValueKey(stepNumber),
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isOptional)
                              Text(
                                "*${context.translate.optional}",
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: titleColor,
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (isCompleted)
                Icon(Icons.check_circle, color: colorScheme.primary, size: 24),
            ],
          ),

          if (isActive || isCompleted)
            Divider(color: colorScheme.outlineVariant, height: 1),

          if (isActive || isCompleted)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: child,
            ),
        ],
      ),
    );
  }
}
