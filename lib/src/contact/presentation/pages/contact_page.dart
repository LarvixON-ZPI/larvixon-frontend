import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/default_padding.dart';
import 'package:larvixon_frontend/src/contact/presentation/widgets/contact_section.dart';

class ContactPage extends StatelessWidget {
  static const String route = '/contact';
  static const String name = 'contact';
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const ContactSection().withDefaultPagePadding,
          ),
        ),
      ),
    );
  }
}
