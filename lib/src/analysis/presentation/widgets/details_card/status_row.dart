import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class StatusRow extends StatelessWidget {
  const StatusRow({super.key, required this.analysis});
  final Analysis? analysis;

  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final statusColor = analysis?.status.color ?? Colors.grey;
    final backgroundColor = statusColor.withValues(alpha: 0.2);
    final icon = analysis?.status.icon ?? Icons.help_outline;
    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        spacing: 4,
        children: [
          AnimatedSwitcher(
            duration: _animationDuration,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(icon, color: statusColor, size: 18),
          ),

          AnimatedDefaultTextStyle(
            duration: _animationDuration,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            child: Text(
              analysis?.status.displayName(context) ??
                  context.translate.loading,
            ),
          ),
        ],
      ),
    );
  }
}
