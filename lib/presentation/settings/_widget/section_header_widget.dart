import 'package:flutter/material.dart';

import 'package:tamfinans_case/core/constants/app_icons_constant.dart';
import 'package:tamfinans_case/core/constants/app_strings.dart';
import 'package:tamfinans_case/presentation/common/widgets/custom_svg_widget.dart';

class SectionHeaderWidget extends StatelessWidget {
  const SectionHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgIconFromAssets(
            iconName: AppIcons.developerMode,
            color: theme.colorScheme.onSurface,
            height: 24,
          ),
        ),
        SizedBox(width: 8),
        Text(
          AppStrings.stateManagement,
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
