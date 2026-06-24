import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._box)
    : _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == _box.get(_themeModeKey),
        orElse: () => ThemeMode.system,
      );

  static const _themeModeKey = 'theme_mode';

  final Box<String> _box;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _box.put(_themeModeKey, mode.name);
  }

  Future<void> toggleDarkMode() {
    return setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
