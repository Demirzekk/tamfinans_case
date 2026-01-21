import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';

enum ThemeType { light, dark }

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.cardBackground,
        surfaceContainerHighest: AppColors.iconBackground,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hintColor: AppColors.secondaryLabel,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceBackground,
        hintStyle: const TextStyle(color: AppColors.secondaryLabel),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: Colors.white,
        surfaceContainerHighest: Colors.grey[200],
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.grey[900]!,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.grey[900],
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class ThemeController extends ChangeNotifier {
  ThemeType _themeType = ThemeType.dark;

  ThemeType get themeType => _themeType;
  ThemeData get theme =>
      _themeType == ThemeType.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
  bool get isDarkMode => _themeType == ThemeType.dark;

  ThemeController() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('darkMode') ?? true;
    _themeType = isDark ? ThemeType.dark : ThemeType.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeType = _themeType == ThemeType.dark
        ? ThemeType.light
        : ThemeType.dark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _themeType == ThemeType.dark);

    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    _themeType = isDark ? ThemeType.dark : ThemeType.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);

    notifyListeners();
  }
}
