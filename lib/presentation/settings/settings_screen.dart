import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamfinans_case/core/extension/state_management_type.dart';
import 'package:tamfinans_case/presentation/settings/_widget/setting_item_widget.dart';
import 'package:tamfinans_case/core/constants/app_strings.dart';
import 'package:tamfinans_case/core/theme/app_colors_extension.dart';

import 'package:tamfinans_case/presentation/settings/_widget/state_management_selector_widget.dart';
import 'package:tamfinans_case/presentation/settings/_widget/theme_select_widget.dart';

import '../../app/di/injection.dart';
import '../../core/constants/app_icons_constant.dart';

class SettingsScreen extends StatefulWidget {
  final ValueChanged<StateManagementType>? onStateManagementChanged;

  const SettingsScreen({super.key, this.onStateManagementChanged});

  @override
  State<SettingsScreen> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsScreen> {
  late final ValueNotifier<StateManagementType> _selectedTypeNotifier;

  @override
  void initState() {
    super.initState();
    _selectedTypeNotifier = ValueNotifier(StateManagementType.bloc);
    _loadStateManagementType();
  }

  @override
  void dispose() {
    _selectedTypeNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadStateManagementType() async {
    final prefs = getIt<SharedPreferences>();
    final index = prefs.getInt('stateManagementType') ?? 0;
    _selectedTypeNotifier.value = StateManagementType.values[index];
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            color:
                appColors.divider ??
                Theme.of(context).colorScheme.surfaceContainerHighest,
            thickness: 1.5,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          ValueListenableBuilder<StateManagementType>(
            valueListenable: _selectedTypeNotifier,
            builder: (context, selectedType, _) {
              return StateManagementSelectorWidget(
                selectedType: selectedType,
                onStateManagementChanged: (type) {
                  _selectedTypeNotifier.value = type;
                  widget.onStateManagementChanged?.call(type);
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 52),
            child: ThemeSelectWidget(isDark: isDark),
          ),
          const SettingItemWidget(
            iconName: AppIcons.version,
            title: AppStrings.version,
            trailing: Text(
              AppStrings.appVersion,
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SettingItemWidget(
            iconName: AppIcons.dataSource,
            title: AppStrings.dataSource,
            trailing: Text(AppStrings.tcmb, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
