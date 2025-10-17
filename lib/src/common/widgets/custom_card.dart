import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.child,
    this.mainAxisSize = MainAxisSize.min,
    this.color,
    this.background,
    this.constraints,
  });
  final Widget? title;
  final Widget? description;
  final Widget? icon;
  final MainAxisSize mainAxisSize;
  final Color? color;
  final Widget? background;
  final Widget? child;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          constraints ??
          const BoxConstraints(
            maxHeight: double.infinity,
            maxWidth: double.infinity,
          ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: color ?? Theme.of(context).cardColor.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            if (background != null) Positioned.fill(child: background!),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: mainAxisSize,
                spacing: 6,
                children: [
                  if (icon != null) icon!,
                  if (title != null) title!,
                  if (description != null) description!,
                  if (child != null) child!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
