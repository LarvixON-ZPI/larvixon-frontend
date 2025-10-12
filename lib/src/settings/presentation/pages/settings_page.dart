import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/settings/presentation/blocs/cubit/settings_cubit.dart';
import 'package:larvixon_frontend/src/settings/presentation/widgets/locale_dropdown_menu.dart';

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
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  ElevatedButton(
                    child: Text("Toggle"),
                    onPressed: () =>
                        context.read<SettingsCubit>().toggleTheme(),
                  ),
                  ElevatedButton(
                    child: Text("Auto"),
                    onPressed: () => context.read<SettingsCubit>().setTheme(
                      theme: ThemeMode.system,
                    ),
                  ),
                  ElevatedButton(
                    child: Text("Dark"),

                    onPressed: () => context.read<SettingsCubit>().setTheme(
                      theme: ThemeMode.dark,
                    ),
                  ),
                  ElevatedButton(
                    child: Text("Light"),

                    onPressed: () => context.read<SettingsCubit>().setTheme(
                      theme: ThemeMode.light,
                    ),
                  ),
                  LocaleDropdownMenu(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
