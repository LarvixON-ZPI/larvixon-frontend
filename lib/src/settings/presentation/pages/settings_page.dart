import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
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
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomCard(
                  title: Text(
                    context.translate.appearance,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const ThemeSelectionButtons(),
                ),
                CustomCard(
                  title: Text(
                    context.translate.language,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
