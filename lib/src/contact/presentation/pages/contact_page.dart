import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_section_base.dart';
import 'package:larvixon_frontend/src/contact/presentation/widgets/contact_section.dart';

class ContactPage extends StatelessWidget {
  static const String route = '/contact';
  static const String name = 'contact';
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: kDefaultPageWidthConstraitns,
            child: Column(
              children: [
                HeaderSectionBase(
                  title: context.translate.contact,
                  subtitle: context.translate.contactDescription,
                ),
                const ContactSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
