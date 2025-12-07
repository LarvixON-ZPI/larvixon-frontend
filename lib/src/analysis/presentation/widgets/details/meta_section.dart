import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details_card/status_row.dart';
import 'package:larvixon_frontend/src/common/extensions/date_format_extension.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:larvixon_frontend/src/patient/domain/entities/patient.dart';

class MetaSection extends StatefulWidget {
  const MetaSection({super.key, required this.analysis});
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${context.translate.status}: ",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              StatusRow(analysis: widget.analysis, showPercent: true),
            ],
          ),
          const Divider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  "${context.translate.createdAt}: ${widget.analysis.uploadedAt.formattedDateTime}",
                  style: Theme.of(context).textTheme.headlineMedium,
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
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
          ),
          if (widget.analysis.patient case final patient?) ...[
            const Divider(),
            _PatientSection(patient: patient),
          ],
          if (widget.analysis.description != null &&
              widget.analysis.description!.isNotEmpty) ...[
            const Divider(),
            _DescriptionSection(description: widget.analysis.description!),
          ],
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatefulWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  State<_DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<_DescriptionSection> {
  bool _isExpanded = false;
  static const int _previewLength = 100;

  bool get _needsExpansion => widget.description.length > _previewLength;

  String get _displayText {
    if (_isExpanded || !_needsExpansion) {
      return widget.description;
    }
    return '${widget.description.substring(0, _previewLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.translate.description,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (_needsExpansion)
              IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
              ),
          ],
        ),
        SelectableText(
          _displayText,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}

class _PatientSection extends StatelessWidget {
  const _PatientSection({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return _PatientSectionExpanded(patient: patient);
  }
}

class _PatientSectionExpanded extends StatefulWidget {
  const _PatientSectionExpanded({required this.patient});

  final Patient patient;

  @override
  State<_PatientSectionExpanded> createState() =>
      _PatientSectionExpandedState();
}

class _PatientSectionExpandedState extends State<_PatientSectionExpanded> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.translate.patient,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ],
        ),
        if (widget.patient.pesel case final pesel?)
          SelectableText(
            "PESEL: $pesel",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        if (widget.patient.firstName case final firstName?)
          SelectableText(
            "${context.translate.firstName}: $firstName",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        if (widget.patient.lastName case final lastName?)
          SelectableText(
            "${context.translate.lastName}: $lastName",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        if (_isExpanded) ...[
          if (widget.patient.birthDate case final birthDate?)
            SelectableText(
              "${context.translate.birthDate}: ${birthDate.formattedDateOnly}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          if (widget.patient.gender case final gender?)
            SelectableText(
              "${context.translate.gender}: ${gender.translate(context)}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          if (widget.patient.phone case final phone?)
            SelectableText(
              "${context.translate.phone}: $phone",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          if (widget.patient.email case final email?)
            SelectableText(
              "${context.translate.email}: $email",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          if (widget.patient.address case final address?)
            SelectableText(
              "${context.translate.address}: $address",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          if (widget.patient.city case final city?)
            SelectableText(
              "${context.translate.city}: $city",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          if (widget.patient.postalCode case final postalCode?)
            SelectableText(
              "${context.translate.postalCode}: $postalCode",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          if (widget.patient.country case final country?)
            SelectableText(
              "${context.translate.country}: $country",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
        ],
      ],
    );
  }
}
