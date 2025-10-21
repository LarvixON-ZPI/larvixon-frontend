import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/status_row.dart';
import 'package:larvixon_frontend/src/common/extensions/date_format_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class MetaSection extends StatefulWidget {
  const MetaSection({required this.analysis});
  final Analysis analysis;

  @override
  State<MetaSection> createState() => _MetaSectionState();
}

class _MetaSectionState extends State<MetaSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.analysis.analysedAt != null) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant MetaSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.analysis.analysedAt == null &&
        widget.analysis.analysedAt != null) {
      _controller.forward();
    } else if (oldWidget.analysis.analysedAt != null &&
        widget.analysis.analysedAt == null) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${context.translate.title}: ${widget.analysis.name ?? context.translate.notSet}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${context.translate.status}: ",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              StatusRow(analysis: widget.analysis, showPercent: true),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  "${context.translate.createdAt}: ${widget.analysis.uploadedAt.formattedDateTime}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            axisAlignment: -1.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    "${context.translate.analysed}: ${widget.analysis.analysedAt?.formattedDateTime ?? ''}",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
