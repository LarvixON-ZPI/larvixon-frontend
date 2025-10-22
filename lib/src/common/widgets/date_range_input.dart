import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DateRangeInput extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final Function(DateTime?, DateTime?) onChanged;

  const DateRangeInput({
    super.key,
    this.initialStart,
    this.initialEnd,
    required this.onChanged,
  });

  @override
  State<DateRangeInput> createState() => _DateRangeInputState();
}

class _DateRangeInputState extends State<DateRangeInput> {
  late TextEditingController startController;
  late TextEditingController endController;
  DateTime? startDate;
  DateTime? endDate;
  final startMaskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final endMaskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStart;
    endDate = widget.initialEnd;
    startController = TextEditingController(
      text: startDate != null ? formatDate(startDate!) : '',
    );
    endController = TextEditingController(
      text: endDate != null ? formatDate(endDate!) : '',
    );
  }

  DateTime? parseInputDate(String input) {
    try {
      final parts = input.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final parsed = DateTime(year, month, day);
      if (parsed.isAfter(DateTime.now())) return DateTime.now();
      return parsed;
    } catch (_) {
      return null;
    }
  }

  void notify() => widget.onChanged(startDate, endDate);

  Future<void> pickStartDate(BuildContext context) async {
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = endDate ?? DateTime.now();

    DateTime initial = startDate ?? DateTime.now();
    if (initial.isBefore(firstDate) || initial.isAfter(lastDate)) {
      initial = DateTime.now();
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (endDate != null && picked.isAfter(endDate!)) endDate = null;
        startDate = picked;
        startController.text = formatDate(picked);
      });
      notify();
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final DateTime firstDate = startDate ?? DateTime(2000);
    final DateTime lastDate = DateTime.now();

    DateTime initial = endDate ?? DateTime.now();
    if (initial.isBefore(firstDate) || initial.isAfter(lastDate)) {
      initial = DateTime.now();
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (startDate != null && picked.isBefore(startDate!)) startDate = null;
        endDate = picked;
        endController.text = formatDate(picked);
      });
      notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translate.datesRange,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Row(
          spacing: 4.0,
          children: [
            SizedBox(width: 60, child: Text(context.translate.from)),
            Expanded(
              child: TextFormField(
                controller: startController,
                inputFormatters: [startMaskFormatter],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'dd/MM/yyyy',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => pickStartDate(context),
                  ),
                ),
                onChanged: (input) {
                  if (input.length < 10) return;
                  final parsed = parseInputDate(input);
                  if (parsed == null) return;
                  if (endDate != null && parsed.isAfter(endDate!)) {
                    setState(() {
                      endDate = parsed;
                      endController.text = formatDate(parsed);
                    });
                  }

                  setState(() {
                    startDate = parsed;
                  });
                  notify();
                },
              ),
            ),
          ],
        ),
        Row(
          spacing: 4.0,
          children: [
            SizedBox(width: 60, child: Text(context.translate.to)),
            Expanded(
              child: TextFormField(
                controller: endController,
                inputFormatters: [endMaskFormatter],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'dd/MM/yyyy',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => pickEndDate(context),
                  ),
                ),
                onChanged: (input) {
                  if (input.length < 10) return;
                  final parsed = parseInputDate(input);
                  if (parsed == null) return;
                  if (startDate != null && parsed.isBefore(startDate!)) {
                    setState(() {
                      startDate = parsed;
                      startController.text = formatDate(parsed);
                    });
                  }

                  setState(() {
                    endDate = parsed;
                  });
                  notify();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
