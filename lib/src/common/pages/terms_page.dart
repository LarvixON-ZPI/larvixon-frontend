import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/mixins/legal_content_mixin.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_section_base.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';

class TermsOfUsePage extends StatefulWidget {
  static const route = "/terms";
  static const name = "terms";
  const TermsOfUsePage({super.key});

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage>
    with LegalContentMixin {
  @override
  String get assetBasePath => 'assets/legal/terms_of_service';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: kDefaultPageWidthConstraitns,
            child: Column(
              children: [
                HeaderSectionBase(title: context.translate.terms),
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
