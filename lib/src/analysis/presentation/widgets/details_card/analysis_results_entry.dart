import 'package:flutter/material.dart';

class AnalysisResultsEntry extends StatefulWidget {
  final String label;
  final double confidence;
  const AnalysisResultsEntry({
    super.key,
    required this.label,
    required this.confidence,
  });

  @override
  State<AnalysisResultsEntry> createState() => _AnalysisResultsEntryState();
}

class _AnalysisResultsEntryState extends State<AnalysisResultsEntry>
    with SingleTickerProviderStateMixin {
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

    final beginColor = _getColor(0);
    final endColor = _getColor(confidence);

    _colorAnimation = ColorTween(
      begin: beginColor,
      end: endColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant AnalysisResultsEntry oldWidget) {
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

  Color _getColor(double confidence) {
    if (confidence < 0.5) return Colors.red;
    if (confidence < 0.75) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          AnimatedBuilder(
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
                  Text(
                    '${(value * 100).toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
