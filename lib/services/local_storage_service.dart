import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  // 🔑 Keys (match WinForms INI semantics)
  static const String _primaryIdKey = 'PrimaryId';
  static const String _lastRunningTemplateKey = 'LastRunningTemplate';
  static const String _lastAppendTemplateKey = 'LastAppendRunningTemplate';

  /// 🔥 MUST be called once after Flutter init
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // PRIMARY SCREEN ID
  // ---------------------------------------------------------------------------

  static Future<void> savePrimaryId(int id) async {
    await _ensureInit();
    await _prefs!.setInt(_primaryIdKey, id);
  }

  static int? getPrimaryIdSync() {
    return _prefs?.getInt(_primaryIdKey);
  }

  static Future<int?> getPrimaryId() async {
    await _ensureInit();
    return _prefs!.getInt(_primaryIdKey);
  }

  static Future<void> clearPrimaryId() async {
    await _ensureInit();
    await _prefs!.remove(_primaryIdKey);
  }

  // ---------------------------------------------------------------------------
  // TEMPLATE STATE (INI EQUIVALENT)
  // ---------------------------------------------------------------------------

  static Future<void> saveLastRunningTemplate(String value) async {
    await _ensureInit();
    await _prefs!.setString(_lastRunningTemplateKey, value);
  }

  static String? getLastRunningTemplate() {
    return _prefs?.getString(_lastRunningTemplateKey);
  }

  static Future<void> saveLastAppendTemplate(String value) async {
    await _ensureInit();
    await _prefs!.setString(_lastAppendTemplateKey, value);
  }

  static String? getLastAppendTemplate() {
    return _prefs?.getString(_lastAppendTemplateKey);
  }

  // ---------------------------------------------------------------------------
  // INTERNAL
  // ---------------------------------------------------------------------------

  static Future<void> _ensureInit() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }
}
