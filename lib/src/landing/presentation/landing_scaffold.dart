import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/locale_controller.dart';
import 'package:larvixon_frontend/src/common/widgets/background.dart';
import 'package:larvixon_frontend/src/common/widgets/footer.dart';
import 'package:larvixon_frontend/src/landing/presentation/landing_navbar.dart';

class LandingScaffold extends StatelessWidget {
  final Widget child;
  const LandingScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final localeController = LocaleController.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundWithLarvae(),
          Column(
            children: [
              LandingNavBar(
                currentLocale: localeController?.locale,
                onLocaleChanged: (locale) {
                  if (locale != null) {
                    localeController?.setLocale(locale);
                  }
                },
              ),
              Expanded(child: child),
            ],
          ),
          Align(alignment: Alignment.bottomRight, child: Footer()),
        ],
      ),
    );
  }
}
