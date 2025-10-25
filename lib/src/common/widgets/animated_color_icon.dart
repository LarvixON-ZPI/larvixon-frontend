import 'package:flutter/material.dart';

class AnimatedColorIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double? size;
  final Duration duration;

  const AnimatedColorIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: color),
      duration: duration,
      builder: (context, animatedColor, child) {
        return Icon(icon, color: animatedColor, size: size);
      },
    );
  }
}
