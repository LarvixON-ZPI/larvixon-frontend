import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/markdown.dart';

mixin LegalContentMixin<T extends StatefulWidget> on State<T> {
  String _content = '';
  bool _isLoading = true;
  bool _hasLoadedContent = false;

  String get content => _content;
  bool get isLoading => _isLoading;

  String get assetBasePath;

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
    if (!_hasLoadedContent) {
      _hasLoadedContent = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _loadContent();
      });
    }
  }

  Future<void> _loadContent() async {
    if (!mounted) return;

    try {
      final locale = Localizations.localeOf(context);
      final languageCode = locale.languageCode;

      final content = await rootBundle.loadString(
        '${assetBasePath}_$languageCode.md',
      );

      if (!mounted) return;
      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      final fallbackContent = await rootBundle.loadString(
        '${assetBasePath}_en.md',
      );
      if (!mounted) return;
      setState(() {
        _content = fallbackContent;
        _isLoading = false;
      });
    }
  }
}
