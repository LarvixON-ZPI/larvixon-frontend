import 'package:flutter/material.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class MockModeBanner extends StatefulWidget {
  final Widget child;

  const MockModeBanner({super.key, required this.child});

  @override
  State<MockModeBanner> createState() => _MockModeBannerState();
}

class _MockModeBannerState extends State<MockModeBanner> {
  bool _isDismissed = false;

  void _dismiss() {
    setState(() {
      _isDismissed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color.fromARGB(168, 195, 84, 0);
    const textColor = Color.fromARGB(255, 255, 251, 244);

    return Column(
      children: [
        if (!_isDismissed)
          Material(
            color: backgroundColor,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: textColor, size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        context.translate.mockModeNotification,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _dismiss,
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, color: textColor, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}
