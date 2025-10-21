import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/color_gradient.dart';

class AnimatedConfidenceBar extends StatefulWidget {
  const AnimatedConfidenceBar({
    super.key,
    required this.confidence,
    this.includePercentage = false,
    this.textStyle,
  });
  final double confidence;
  final bool includePercentage;
  final TextStyle? textStyle;

  @override
  State<AnimatedConfidenceBar> createState() => _AnimatedConfidenceBarState();
}

class _AnimatedConfidenceBarState extends State<AnimatedConfidenceBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  late Duration _duration;
  @override
  void initState() {
    super.initState();
    _duration = Duration(
      milliseconds: 300 + (1200 * widget.confidence).toInt(),
    );

    _controller = AnimationController(vsync: this, duration: _duration);
    _setupAnimations(widget.confidence);
    _controller.forward();
  }

  void _setupAnimations(double confidence) {
    _animation = Tween<double>(
      begin: 0,
      end: confidence,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    final beginColor = ColorGradientExtension.gradient(score: 0);
    final endColor = ColorGradientExtension.gradient(score: confidence);

    _colorAnimation = ColorTween(
      begin: beginColor,
      end: endColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant AnimatedConfidenceBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.confidence != widget.confidence) {
      _controller.reset();
      _setupAnimations(widget.confidence);
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _animation.value;
        return Row(
          spacing: 8,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color?>(
                  _colorAnimation.value,
                ),
              ),
            ),
            if (widget.includePercentage)
              Text(
                '${(value * 100).toStringAsFixed(1)}%',
                style:
                    widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        );
      },
    );
  }
}
