import 'package:flutter/material.dart';

import 'custom_svg_widget.dart';

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({
    super.key,
    required this.iconName,
    required this.size,
    this.isCircle,
  });

  final String iconName;
  final double size;
  final bool? isCircle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: SvgIconFromAssets(
        iconName: iconName,
        color: theme.colorScheme.onSurface,
        height: size,
      ),
    );
  }
}
