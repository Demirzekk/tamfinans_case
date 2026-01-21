import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'app/di/injection.dart';
import 'presentation/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('tr_TR', null);

  await setupDependencies();

  runApp(const TamFinansApp());
}

class TamFinansApp extends StatelessWidget {
  const TamFinansApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Tamfinans Demo App',
          debugShowCheckedModeBanner: false,
          theme: themeController.theme,
          themeAnimationDuration: const Duration(milliseconds: 300),
          themeAnimationCurve: Curves.easeInOut,
          home: const HomeScreen(),
        );
      },
    );
  }
}
