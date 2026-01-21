import 'package:flutter/material.dart';

import 'package:tamfinans_case/presentation/common/widgets/icon_widget.dart'
    show AppIconWidget;

class SettingItemWidget extends StatelessWidget {
  const SettingItemWidget({
    super.key,
    required this.iconName,
    required this.title,
    required this.trailing,
  });
  final String iconName;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cardColor = theme.cardTheme.color;
    final textColor = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: theme.colorScheme.surfaceContainerHighest,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          AppIconWidget(iconName: iconName, size: 24, isCircle: false),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
