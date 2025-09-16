import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.children,
    this.mainAxisSize = MainAxisSize.min,
    this.useWrap = true,
    this.color,
  });
  final String? title;
  final String? description;
  final IconData? icon;
  final List<Widget>? children;
  final MainAxisSize mainAxisSize;
  final bool useWrap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.white.withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: mainAxisSize,
          spacing: 6,
          children: [
            if (icon != null)
              Column(children: [Icon(icon, size: 40), SizedBox(height: 2)]),
            if (title != null)
              Text(title!, style: Theme.of(context).textTheme.titleMedium),
            if (description != null)
              Column(
                children: [
                  Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

            if (children != null)
              if (useWrap) ...[
                Wrap(spacing: 12, runSpacing: 12, children: children!),
              ] else
                ...children!,
          ],
        ),
      ),
    );
  }
}
