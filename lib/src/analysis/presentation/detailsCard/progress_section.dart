import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/larva_video.dart';
import 'package:larvixon_frontend/src/analysis/larva_video_status.dart';

class ProgressSection extends StatefulWidget {
  final LarvaVideo? video;
  final double progress;
  const ProgressSection({super.key, this.video, required this.progress});

  @override
  State<ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<ProgressSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<Color?> _colorAnimation;
  double _currentProgress = 0.0;
  Color _currentColor = Colors.grey;

  static const Duration _duration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _progressAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _colorAnimation = ColorTween(
      begin: _currentColor,
      end: _currentColor,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant ProgressSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final status = widget.video?.status ?? LarvaVideoStatus.pending;
    final newColor = status.color;
    if (widget.progress != oldWidget.progress || newColor != _currentColor) {
      _animateTo(widget.progress, newColor);
    }
  }

  void _animateTo(double newProgress, Color newColor) {
    _progressAnimation = Tween<double>(
      begin: _currentProgress,
      end: newProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _colorAnimation = ColorTween(
      begin: _currentColor,
      end: newColor,
    ).animate(_controller);

    _controller
      ..reset()
      ..forward();

    _currentProgress = newProgress;
    _currentColor = newColor;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.video?.status ?? LarvaVideoStatus.pending;
    final enabled =
        !(status == LarvaVideoStatus.completed ||
            status == LarvaVideoStatus.failed);

    if (!enabled) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          spacing: 6,
          children: [
            Text(
              '${(_progressAnimation.value * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color?>(_colorAnimation.value),
            ),
          ],
        );
      },
    );
  }
}
