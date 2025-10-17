import 'package:flutter/material.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_dropdown_menu.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/theme_selection_buttons.dart';

class SettingsDropdownMenu extends StatefulWidget {
  const SettingsDropdownMenu({super.key});

  @override
  State<SettingsDropdownMenu> createState() => _SettingsDropdownMenuState();
}

class _SettingsDropdownMenuState extends State<SettingsDropdownMenu>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Widget>(
      icon: AnimatedRotation(
        duration: const Duration(milliseconds: 300),
        turns: _isOpen ? 0.25 : 0.0,
        child: Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
      ),
      offset: const Offset(0, 40),
      onOpened: () => setState(() => _isOpen = true),
      onCanceled: () => setState(() => _isOpen = false),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Column(
            children: [
              Text(context.translate.appearance),
              const ThemeSelectionButtons(),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: Column(
            children: [
              Text(context.translate.language),
              const Center(
                child: LocaleDropdownMenu(includeTrailingIcon: false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
