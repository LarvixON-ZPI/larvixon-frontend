import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/landing/presentation/contact_section.dart';

class ContactPage extends StatelessWidget {
  static const String route = '/contact';
  static const String name = 'contact';
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: ContactSection(),
        ),
      ),
    );
  }
}
