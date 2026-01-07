import 'package:shared_preferences/shared_preferences.dart';

class SignageConfigService {
  static const _keyBaseUrl = 'base_url';

  static Future<void> saveBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBaseUrl, url.trim());
  }

  static Future<String?> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBaseUrl);
  }

  static Future<bool> hasBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyBaseUrl);
  }
}
