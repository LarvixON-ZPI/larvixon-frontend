import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_section_base.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class SimulationPage extends StatelessWidget {
  static const String route = '/simulation';
  static const String name = 'simulation';

  const SimulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: kDefaultPageWidthConstraitns,
                child: Column(
                  children: [
                    HeaderSectionBase(
                      title: context.translate.simulation,
                      subtitle: context.translate.simulationDescription,
                    ),
                    const CustomCard(child: Text("Unsupported")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
