import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamfinans_case/app/di/injection.dart' show getIt;
import 'package:tamfinans_case/core/extension/state_management_type.dart';
import 'package:tamfinans_case/core/platform/security_channel.dart';

class HomeScreenController extends ChangeNotifier {
  StateManagementType _currentType = StateManagementType.getx;
  bool _isSecurityOverlayVisible = false;
  StreamSubscription<SecurityEvent>? _securitySubscription;

  StateManagementType get currentType => _currentType;
  bool get isSecurityOverlayVisible => _isSecurityOverlayVisible;

  HomeScreenController() {
    _init();
  }

  Future<void> _init() async {
    await _loadStateManagementType();
    _setupSecurityListener();
    _checkScreenRecording();
    await SecurityChannel.enableSecurityProtection();
  }

  Future<void> _loadStateManagementType() async {
    final prefs = getIt<SharedPreferences>();
    final typeIndex = prefs.getInt('stateManagementType') ?? 0;
    _currentType = StateManagementType.values[typeIndex];
    notifyListeners();
  }

  void _setupSecurityListener() {
    _securitySubscription = SecurityChannel.securityEvents.listen((event) {
      switch (event) {
        case SecurityEvent.screenshotTaken:
          break;
        case SecurityEvent.screenRecordingStarted:
          _isSecurityOverlayVisible = true;
          notifyListeners();
          break;
        case SecurityEvent.screenRecordingStopped:
          _isSecurityOverlayVisible = false;
          notifyListeners();
          break;
      }
    });
  }

  Future<void> _checkScreenRecording() async {
    final isRecording = await SecurityChannel.isScreenBeingRecorded;
    if (isRecording) {
      _isSecurityOverlayVisible = true;
      notifyListeners();
    }
  }

  void updateStateManagementType(StateManagementType type) {
    _currentType = type;
    notifyListeners();
  }

  void reloadStateManagementType() {
    _loadStateManagementType();
  }

  @override
  void dispose() {
    _securitySubscription?.cancel();
    super.dispose();
  }
}
