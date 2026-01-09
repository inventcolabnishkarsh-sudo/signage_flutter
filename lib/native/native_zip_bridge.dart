import 'package:flutter/services.dart';

class NativeZipBridge {
  static const MethodChannel _channel = MethodChannel('native_zip');

  static Future<bool> unzip({
    required String zipPath,
    required String destPath,
  }) async {
    final result = await _channel.invokeMethod<bool>('unzip', {
      'zipPath': zipPath,
      'destPath': destPath,
    });

    return result ?? false;
  }
}
