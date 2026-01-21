import 'package:flutter/material.dart';

class AppDatePicker {
  AppDatePicker._();

  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime currentDate,
  }) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    var initialDate = currentDate;
    if (initialDate.isAfter(today)) {
      initialDate = today;
    }
    // Hafta sonu kontrolü (Cumartesi: 6, Pazar: 7)
    while (initialDate.weekday == 6 || initialDate.weekday == 7) {
      initialDate = initialDate.subtract(const Duration(days: 1));
    }

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: today,
      selectableDayPredicate: (date) {
        final checkDate = DateTime(date.year, date.month, date.day);
        if (checkDate.isAfter(today)) return false;
        if (date.weekday == 6 || date.weekday == 7) return false;
        return true;
      },
      builder: (context, child) {
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: theme.colorScheme.primary,
                    onPrimary: Colors.white,
                    surface: const Color(0xFF1E1E1E),
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: theme.colorScheme.primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.grey[900]!,
                  ),
                ),
          child: child!,
        );
      },
    );
  }
}
