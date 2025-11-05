import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/default_padding.dart';
import 'package:larvixon_frontend/src/about_us/presentation/widgets/about_section.dart';

class AboutPage extends StatelessWidget {
  static const String route = '/about';
  static const String name = 'about';
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const AboutSection().withDefaultPagePadding,
          ),
        ),
      ),
    );
  }
}
