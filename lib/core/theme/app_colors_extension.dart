import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.surfaceContainerLowest,
    required this.iconBackground,
    required this.surfaceBackground,
    required this.selectedDateBg,
    required this.unselectedDateBg,
    required this.textSecondary,
    required this.textHint,
    required this.success,
    required this.warning,
    required this.divider,
    required this.securityOverlayBackground,
  });

  final Color? surfaceContainerLowest;
  final Color? iconBackground;
  final Color? surfaceBackground;
  final Color? selectedDateBg;
  final Color? unselectedDateBg;
  final Color? textSecondary;
  final Color? textHint;
  final Color? success;
  final Color? warning;
  final Color? divider;
  final Color? securityOverlayBackground;

  @override
  AppColorsExtension copyWith({
    Color? surfaceContainerLowest,
    Color? iconBackground,
    Color? surfaceBackground,
    Color? selectedDateBg,
    Color? unselectedDateBg,
    Color? textSecondary,
    Color? textHint,
    Color? success,
    Color? warning,
    Color? divider,
    Color? securityOverlayBackground,
  }) {
    return AppColorsExtension(
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      iconBackground: iconBackground ?? this.iconBackground,
      surfaceBackground: surfaceBackground ?? this.surfaceBackground,
      selectedDateBg: selectedDateBg ?? this.selectedDateBg,
      unselectedDateBg: unselectedDateBg ?? this.unselectedDateBg,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      divider: divider ?? this.divider,
      securityOverlayBackground:
          securityOverlayBackground ?? this.securityOverlayBackground,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      ),
      iconBackground: Color.lerp(iconBackground, other.iconBackground, t),
      surfaceBackground: Color.lerp(
        surfaceBackground,
        other.surfaceBackground,
        t,
      ),
      selectedDateBg: Color.lerp(selectedDateBg, other.selectedDateBg, t),
      unselectedDateBg: Color.lerp(unselectedDateBg, other.unselectedDateBg, t),
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
      textHint: Color.lerp(textHint, other.textHint, t),
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      divider: Color.lerp(divider, other.divider, t),
      securityOverlayBackground: Color.lerp(
        securityOverlayBackground,
        other.securityOverlayBackground,
        t,
      ),
    );
  }
}
