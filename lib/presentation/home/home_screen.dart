import 'package:flutter/material.dart';

import 'package:tamfinans_case/core/constants/app_icons_constant.dart';
import 'package:tamfinans_case/core/constants/app_strings.dart';
import 'package:tamfinans_case/core/extension/state_management_type.dart';
import 'package:tamfinans_case/presentation/common/widgets/custom_svg_widget.dart';
import 'package:tamfinans_case/presentation/home/_widgets/security_overlay_widget.dart';
import 'package:tamfinans_case/presentation/home/home_controller.dart';
import 'dart:async';

import '../../core/platform/security_channel.dart';
import '../main_screen/bloc/screens/currency_screen_bloc.dart';
import '../main_screen/mobx/screens/currency_screen_mobx.dart';
import '../main_screen/getx/screens/currency_screen_getx.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeScreenController _controller;
  StreamSubscription<SecurityEvent>? _snackbarSubscription;

  @override
  void initState() {
    super.initState();
    _controller = HomeScreenController();
    _setupSnackbarListener();
  }

  void _setupSnackbarListener() {
    _snackbarSubscription = SecurityChannel.securityEvents.listen((event) {
      if (event == SecurityEvent.screenshotTaken) {
        _showSecurityWarning('Ekran görüntüsü algılandı!');
      } else if (event == SecurityEvent.screenRecordingStarted) {
        _showSecurityWarning('Ekran kaydı algılandı!');
      }
    });
  }

  @override
  void dispose() {
    _snackbarSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _showSecurityWarning(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,

            title: Row(
              children: [
                SvgIconFromAssets(iconName: AppIcons.home),
                const SizedBox(width: 12),
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: isDark ? Colors.white : Colors.grey[700],
                ),
                onPressed: () => _openSettings(),
              ),
            ],
          ),
          body: _controller.isSecurityOverlayVisible
              ? const SecurityOverlayWidget()
              : _buildCurrencyScreen(_controller.currentType),
        );
      },
    );
  }

  Widget _buildCurrencyScreen(StateManagementType type) {
    switch (type) {
      case StateManagementType.bloc:
        return const CurrencyScreenBloc();
      case StateManagementType.mobx:
        return const CurrencyScreenMobx();
      case StateManagementType.getx:
        return const CurrencyScreenGetx();
    }
  }

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          onStateManagementChanged: (type) {
            _controller.updateStateManagementType(type);
          },
        ),
      ),
    );

    // Ayarlardan dönünce tekrar yükle
    _controller.reloadStateManagementType();
  }
}
