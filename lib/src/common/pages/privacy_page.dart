import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/legal_content_mixin.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_section_base.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class PrivacyPolicyPage extends StatefulWidget {
  static const route = "/privacy-policy";
  static const name = "privacy-policy";
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage>
    with LegalContentMixin {
  @override
  String get assetBasePath => 'assets/legal/privacy_policy';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: kDefaultPageWidthConstraitns,
            child: Column(
              children: [
                HeaderSectionBase(title: context.translate.privacyPolicy),
                CustomCard(
                  child: SizedBox(
                    width: double.infinity,
                    child: buildMarkdown(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
