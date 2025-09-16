import 'package:flutter/material.dart';

class _HoverWidget extends StatefulWidget {
  final Widget child;
  const _HoverWidget({super.key, required this.child});

  @override
  State<_HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<_HoverWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _isHovered ? 1.03 : 1.0,
        child: widget.child,
      ),
    );
  }
}

extension HoverExtension on Widget {
  Widget get withOnHoverEffect => _HoverWidget(key: key, child: this);
}
