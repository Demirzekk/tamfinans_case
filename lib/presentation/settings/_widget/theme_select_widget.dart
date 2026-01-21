import 'package:flutter/material.dart';
import 'package:tamfinans_case/app/di/injection.dart';
import 'package:tamfinans_case/core/constants/app_icons_constant.dart';
import 'package:tamfinans_case/core/theme/app_theme.dart';
import 'package:tamfinans_case/presentation/common/widgets/icon_widget.dart';

class ThemeSelectWidget extends StatelessWidget {
  const ThemeSelectWidget({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color;
    final textColor = theme.colorScheme.onSurface;

    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: cardColor),
      child: Row(
        children: [
          AppIconWidget(iconName: AppIcons.darkMode, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Karanlık Mod',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          Switch(
            value: isDark,
            onChanged: (value) {
              themeController.setDarkMode(value);
            },
            activeTrackColor: primaryColor,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
