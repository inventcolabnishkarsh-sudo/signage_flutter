import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';

class DeviceService {
  /// Acts as MAC address replacement on Android
  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;

      // ANDROID_ID is the only stable, Play-Store-safe identifier
      return android.id;
    }

    return 'unknown-device';
  }

  static Future<Map<String, String>> getScreenResolution() async {
    final size = await _getScreenSize();
    return {'width': size.$1.toString(), 'height': size.$2.toString()};
  }

  static Future<(int, int)> _getScreenSize() async {
    final window = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = window.physicalSize;
    return (size.width.toInt(), size.height.toInt());
  }
}
