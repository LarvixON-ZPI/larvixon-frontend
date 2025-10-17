import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';
import 'package:larvixon_frontend/src/settings/presentation/blocs/cubit/settings_cubit.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_dropdown_menu.dart';
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
          child: Column(
            children: [
              CustomCard(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  spacing: 16,
                  children: [
                    Text(context.translate.appearance),
                    const ThemeSelectionButtons(),
                  ],
                ),
              ),
              CustomCard(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  spacing: 16,
                  children: [
                    Text(context.translate.language),
                    const LocaleWrapList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
