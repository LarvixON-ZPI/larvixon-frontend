import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class ProgressSection extends StatefulWidget {
  final AnalysisProgressStatus status;

  const ProgressSection({super.key, required this.status});

  @override
  State<ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<ProgressSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  double _displayedProgress = 0.0;
  double _targetProgress = 0.0;

  AnalysisProgressStatus? _previousStatus;
  bool _showingCompletionCelebration = false;

  static const Duration fastJump = Duration(milliseconds: 800);
  static const Duration slowCrawl = Duration(seconds: 6);
  static const Duration celebrationDelay = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: slowCrawl, vsync: this);

    _animation =
        Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.linear),
        )..addListener(() {
          setState(() {
            _displayedProgress = _animation.value;
          });
        });

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _previousStatus = widget.status;
    _applyStatus(widget.status, isInitial: true);
  }

  @override
  void didUpdateWidget(covariant ProgressSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.status != _previousStatus) {
      _applyStatus(widget.status, isStatusChange: true);
      _previousStatus = widget.status;

      if (widget.status == AnalysisProgressStatus.processing ||
          widget.status == AnalysisProgressStatus.pending) {
        _pulseController.repeat(reverse: true);
        _rotationController.repeat();
      } else {
        _pulseController.stop();
        _pulseController.value = 0;
        _rotationController.stop();
        _rotationController.value = 0;
      }
    }
  }

  void _applyStatus(
    AnalysisProgressStatus status, {
    bool isInitial = false,
    bool isStatusChange = false,
  }) {
    if (status == AnalysisProgressStatus.pending) {
      if (isInitial) {
        _pulseController.repeat(reverse: true);
        _rotationController.repeat();
      }
      _setTarget(0.49, duration: slowCrawl, curve: Curves.linear);
    } else if (status == AnalysisProgressStatus.processing) {
      if (isInitial) {
        _pulseController.repeat(reverse: true);
        _rotationController.repeat();
      }
      if (isStatusChange) {
        _animateTwoPhase(fastTarget: 0.50, slowTarget: 0.99);
      } else {
        _setTarget(0.99, duration: slowCrawl, curve: Curves.linear);
      }
    } else if (status == AnalysisProgressStatus.completed) {
      _controller.stop();
      setState(() {
        _displayedProgress = 1.0;
        _showingCompletionCelebration = true;
      });

      Future.delayed(celebrationDelay, () {
        if (mounted) {
          setState(() => _showingCompletionCelebration = false);
        }
      });
    }
  }

  Future<void> _animateTwoPhase({
    required double fastTarget,
    required double slowTarget,
  }) async {
    _setTarget(fastTarget, duration: fastJump, curve: Curves.easeOutCubic);
    await _controller.forward();

    if (mounted && widget.status == AnalysisProgressStatus.processing) {
      _setTarget(slowTarget, duration: slowCrawl, curve: Curves.linear);
    }
  }

  void _setTarget(
    double newTarget, {
    required Duration duration,
    required Curve curve,
  }) {
    if (newTarget <= _displayedProgress) return;

    _targetProgress = newTarget;

    _animation = Tween<double>(
      begin: _displayedProgress,
      end: _targetProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: curve));

    _controller
      ..duration = duration
      ..reset()
      ..forward();
  }

  Color _getGradientEndColor(Color startColor) {
    final hslColor = HSLColor.fromColor(startColor);
    return hslColor
        .withHue((hslColor.hue + 60) % 360)
        .withLightness((hslColor.lightness * 1.2).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == AnalysisProgressStatus.completed &&
        !_showingCompletionCelebration) {
      return const SizedBox.shrink();
    }

    IconData icon;
    String label;

    switch (widget.status) {
      case AnalysisProgressStatus.pending:
        icon = Icons.hourglass_empty;
        label = context.translate.pending;
        break;
      case AnalysisProgressStatus.processing:
        icon = Icons.auto_awesome;
        label = context.translate.processing;
        break;
      case AnalysisProgressStatus.completed:
        icon = Icons.check_circle;
        label = context.translate.completed;
        break;
      case AnalysisProgressStatus.failed:
        icon = Icons.error_outline;
        label = context.translate.failed;
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 2,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final isAnimating =
                widget.status == AnalysisProgressStatus.processing ||
                widget.status == AnalysisProgressStatus.pending;
            final scale = isAnimating ? _pulseAnimation.value : 1.0;

            return Transform.scale(
              scale: scale,
              child: Container(
                width: 80,
                height: 80,
                decoration: isAnimating
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.status.color.withValues(alpha: 0.4),
                            blurRadius: 12 * _pulseAnimation.value,
                            spreadRadius: 2 * _pulseAnimation.value,
                          ),
                        ],
                      )
                    : null,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.status != AnalysisProgressStatus.failed)
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CustomPaint(
                          painter: _GradientCircularProgressPainter(
                            progress: _displayedProgress,
                            startColor: widget.status.color,
                            endColor: _getGradientEndColor(widget.status.color),
                            backgroundColor: Colors.grey.withValues(alpha: 0.2),
                            strokeWidth: 4,
                          ),
                        ),
                      ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isAnimating
                            ? widget.status.color.withValues(alpha: 0.1)
                            : Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: AnimatedBuilder(
                          key: ValueKey(widget.status),
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: isAnimating ? _rotationAnimation.value : 0,
                              child: Icon(
                                icon,
                                size: 32,
                                color: widget.status.color,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (widget.status != AnalysisProgressStatus.failed) ...[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            "${(_displayedProgress * 100).toStringAsFixed(0)}%",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: widget.status.color,
            ),
          ),
        ],
      ],
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final Color startColor;
  final Color endColor;
  final Color backgroundColor;
  final double strokeWidth;

  _GradientCircularProgressPainter({
    required this.progress,
    required this.startColor,
    required this.endColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        colors: [startColor, endColor, startColor],
        stops: const [0.0, 0.5, 1.0],
        startAngle: -3.14159 / 2,
        endAngle: 3.14159 * 1.5,
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -3.14159 / 2, // Start from top
        2 * 3.14159 * progress, // Sweep angle based on progress
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GradientCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
