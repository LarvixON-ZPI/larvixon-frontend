import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_section_base.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/markdown.dart';

class TermsOfUsePage extends StatefulWidget {
  static const route = "/terms";
  static const name = "terms";
  const TermsOfUsePage({super.key});

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  String _content = '';
  bool _isLoading = true;
  Widget buildMarkdown(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = isDark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;
    return MarkdownWidget(data: _content, config: config, shrinkWrap: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() => _isLoading = true);

    try {
      final locale = Localizations.localeOf(context);
      final languageCode = locale.languageCode;

      final content = await rootBundle.loadString(
        'assets/legal/terms_of_service_$languageCode.md',
      );

      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      final fallbackContent = await rootBundle.loadString(
        'assets/legal/terms_of_service_en.md',
      );
      setState(() {
        _content = fallbackContent;
        _isLoading = false;
      });
    }
  }

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
