import 'package:flutter/services.dart';

class NativeWebViewBridge {
  static const MethodChannel _channel =
  MethodChannel('native_webview');

  /// 🔥 Load & show template
  static Future<void> loadTemplate(String url) async {
    await _channel.invokeMethod('loadTemplate', {
      'url': url,
    });
  }

  /// 🔥 Show WebView
  static Future<void> show() async {
    await _channel.invokeMethod('showWebView');
  }

  /// 🔥 Hide WebView
  static Future<void> hide() async {
    await _channel.invokeMethod('hideWebView');
  }

  /// 🔥 Clear WebView (about:blank)
  static Future<void> clear() async {
    await _channel.invokeMethod('clearWebView');
  }
}
