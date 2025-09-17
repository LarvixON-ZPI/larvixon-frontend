import 'package:flutter/material.dart';

import 'landing_content.dart';

class LandingPage extends StatefulWidget {
  static const String route = '/';
  static const String name = 'landing';

  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: const LandingContent());
  }
}
