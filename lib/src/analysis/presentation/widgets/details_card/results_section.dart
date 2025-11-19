import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_results.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/analysis_results_entry.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class ResultsSection extends StatefulWidget {
  final AnalysisResults results;
  const ResultsSection({super.key, required this.results});

  @override
  State<ResultsSection> createState() => _ResultsSectionState();
}

class _ResultsSectionState extends State<ResultsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.results.length * 100),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_animationStarted) {
        _controller.forward();
        _animationStarted = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const entryHeight = 55.0;
        final totalHeight = constraints.maxHeight;
        final visibleCount = widget.results.length;
        final maxFit = ((totalHeight / entryHeight).floor()).clamp(
          0,
          visibleCount,
        );
        final visibleResults = widget.results.take(maxFit).toList();
        final remaining = widget.results.length - visibleResults.length;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...visibleResults.asMap().entries.map((entry) {
              final index = entry.key;
              final r = entry.value;
              final start =
                  index / (visibleResults.length + (remaining > 0 ? 1 : 0));
              final end =
                  (index + 1) /
                  (visibleResults.length + (remaining > 0 ? 1 : 0));

              return FadeTransition(
                opacity: _controller.drive(
                  CurveTween(
                    curve: Interval(start, end, curve: Curves.easeOut),
                  ),
                ),
                child: SlideTransition(
                  position: _controller.drive(
                    Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).chain(
                      CurveTween(
                        curve: Interval(start, end, curve: Curves.easeOut),
                      ),
                    ),
                  ),
                  child: AnalysisResultsEntry(label: r.$1, confidence: r.$2),
                ),
              );
            }),
            if (remaining > 0)
              FadeTransition(
                opacity: _controller.drive(
                  CurveTween(
                    curve: Interval(
                      visibleResults.length / (visibleResults.length + 1),
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                child: SlideTransition(
                  position: _controller.drive(
                    Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).chain(
                      CurveTween(
                        curve: Interval(
                          visibleResults.length / (visibleResults.length + 1),
                          1.0,
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '+${context.translate.andMore(remaining)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
