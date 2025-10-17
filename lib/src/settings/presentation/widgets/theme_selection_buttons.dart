import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/settings/presentation/blocs/cubit/settings_cubit.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/theme_button.dart';

class ThemeSelectionButtons extends StatelessWidget {
  const ThemeSelectionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final themeMode = state.theme;
        final isAuto = themeMode == ThemeMode.system;
        final isLight =
            themeMode == ThemeMode.light ||
            (themeMode == ThemeMode.system &&
                WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.light);
        final isDark =
            themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.dark);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ThemeButton(
              icon: Icons.settings_brightness,
              selected: isAuto,
              onPressed: () => context.read<SettingsCubit>().setTheme(
                theme: ThemeMode.system,
              ),
              tooltip: context.translate.systemDefault,
            ),
            ThemeButton(
              icon: Icons.sunny,
              selected: isLight,
              onPressed: () => context.read<SettingsCubit>().setTheme(
                theme: ThemeMode.light,
              ),
              tooltip: context.translate.lightMode,
            ),
            ThemeButton(
              icon: FontAwesomeIcons.moon,
              selected: isDark,
              onPressed: () =>
                  context.read<SettingsCubit>().setTheme(theme: ThemeMode.dark),
              tooltip: context.translate.darkMode,
            ),
          ],
        );
      },
    );
  }
}
