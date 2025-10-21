import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class StatusRow extends StatelessWidget {
  const StatusRow({
    super.key,
    required this.analysis,
    this.showPercent = false,
  });
  final Analysis? analysis;
  final bool showPercent;

  static const Duration _animationDuration = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    final statusColor = analysis?.status.color ?? Colors.grey;
    final backgroundColor = statusColor.withValues(alpha: 0.2);
    final icon = analysis?.status.icon ?? Icons.help_outline;
    final displayText =
        analysis?.status.displayName(context) ?? context.translate.loading;

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
          _AnimatedStatusIcon(
            key: ValueKey(icon),
            icon: icon,
            color: statusColor,
            rotate: _shouldRotate,
          ),

          AnimatedDefaultTextStyle(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            child: Text(
              "$displayText${(_shouldShowProgressPercent) ? ' (${((analysis?.status.progressValue ?? 0.0) * 100).toStringAsFixed(0)}%)' : ''}",
            ),
          ),
        ],
      ),
    );
  }

  bool get _shouldShowProgressPercent =>
      showPercent && analysis?.status != AnalysisProgressStatus.completed;

  bool get _shouldRotate =>
      analysis?.status == AnalysisProgressStatus.processing ||
      analysis?.status == AnalysisProgressStatus.pending;
}

class _AnimatedStatusIcon extends StatefulWidget {
  const _AnimatedStatusIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.rotate,
  });

  final IconData icon;
  final Color color;
  final bool rotate;

  @override
  State<_AnimatedStatusIcon> createState() => _AnimatedStatusIconState();
}

class _AnimatedStatusIconState extends State<_AnimatedStatusIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    if (widget.rotate) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant _AnimatedStatusIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.rotate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.rotate && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: Icon(
          widget.icon,
          key: ValueKey(widget.icon),
          color: widget.color,
          size: 18,
        ),
      ),
    );
  }
}
