import 'dart:developer';

import 'package:flutter/services.dart';

enum SecurityEvent {
  screenshotTaken,
  screenRecordingStarted,
  screenRecordingStopped,
}

class SecurityChannel {
  static const _channel = MethodChannel('com.tamfinans/security');
  static const _eventChannel = EventChannel('com.tamfinans/security/events');

  static Stream<SecurityEvent> get securityEvents {
    return _eventChannel.receiveBroadcastStream().map((event) {
      switch (event) {
        case 'screenshot':
          return SecurityEvent.screenshotTaken;
        case 'recording_started':
          return SecurityEvent.screenRecordingStarted;
        case 'recording_stopped':
          return SecurityEvent.screenRecordingStopped;
        default:
          return SecurityEvent.screenshotTaken;
      }
    });
  }

  static Future<bool> get isScreenBeingRecorded async {
    try {
      final result = await _channel.invokeMethod<bool>('isScreenRecording');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> enableSecurityProtection() async {
    try {
      await _channel.invokeMethod('enableProtection');
    } on PlatformException catch (e) {
      log('Security protection error: ${e.message}');
    }
  }

  static Future<void> disableSecurityProtection() async {
    try {
      await _channel.invokeMethod('disableProtection');
    } on PlatformException catch (e) {
      log('Security protection error: ${e.message}');
    }
  }
}
