import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/about_us/presentation/widgets/about_section.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_section_base.dart';

class AboutPage extends StatelessWidget {
  static const String route = '/about';
  static const String name = 'about';
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: kDefaultPageWidthConstraitns,
            child: Column(
              children: [
                HeaderSectionBase(title: context.translate.about),
                const AboutSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
