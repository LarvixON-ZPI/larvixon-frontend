import 'package:flutter/material.dart';

class ThemeButton extends StatefulWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;

  const ThemeButton({
    super.key,
    required this.icon,
    required this.selected,
    required this.onPressed,
    this.tooltip,
    this.color,
  });

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      upperBound: 0.6,
    );
  }

  @override
  void didUpdateWidget(covariant ThemeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.selected && widget.selected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return ScaleTransition(
      scale: Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
      child: IconButton(
        tooltip: widget.tooltip,
        icon: Icon(widget.icon, color: widget.selected ? color : null),
        onPressed: widget.onPressed,
      ),
    );
  }
}
