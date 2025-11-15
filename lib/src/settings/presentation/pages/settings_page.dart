import 'package:flutter/material.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/layout/header_section_base.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_wrap_list.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/theme_selection_buttons.dart';

class SettingsPage extends StatefulWidget {
  static const route = '/settings';
  static const name = 'settings';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: kDefaultPageWidthConstraitns,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeaderSectionBase(title: context.translate.settings),
                CustomCard(
                  title: Text(
                    context.translate.appearance,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  child: const ThemeSelectionButtons(),
                ),
                CustomCard(
                  title: Text(
                    context.translate.language,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  child: const Center(child: LocaleWrapList()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
