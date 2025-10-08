import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/default_padding.dart';
import 'package:larvixon_frontend/src/landing/presentation/about/about_section.dart';

class AboutPage extends StatelessWidget {
  static const String route = '/about';
  static const String name = 'about';
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: AboutSection(),
      ).withDefaultPagePadding,
    );
  }
}
