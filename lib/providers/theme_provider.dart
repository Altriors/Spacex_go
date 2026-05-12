import 'package:flutter/material.dart';
import '../data/services/storage_service.dart';
import '../core/constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    await _storage.init();
    final savedTheme = _storage.getString(AppConstants.keyThemeMode);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storage.saveString(AppConstants.keyThemeMode, mode.toString());
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}