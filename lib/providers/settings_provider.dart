import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider with ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _themeKey = 'isDarkMode';
  static const String _metricKey = 'isMetric';

  late Box _box;
  bool _isDarkMode = false;
  bool _isMetric = true;

  bool get isDarkMode => _isDarkMode;
  bool get isMetric => _isMetric;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  String get unitSystem => _isMetric ? 'metric' : 'imperial';

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    _isDarkMode = _box.get(_themeKey, defaultValue: false);
    _isMetric = _box.get(_metricKey, defaultValue: true);
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    await _box.put(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleUnitSystem(bool value) async {
    _isMetric = value;
    await _box.put(_metricKey, _isMetric);
    notifyListeners();
  }
}
