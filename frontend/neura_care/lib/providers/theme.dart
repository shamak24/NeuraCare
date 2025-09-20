import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends StateNotifier<ThemeMode> {
  ThemeProvider() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';
  static const String _themeBoxName = 'themeBox';

  // Load theme preference from Hive storage
  Future<void> _loadTheme() async {
    try {
      final box = await Hive.openBox(_themeBoxName);
      final themeIndex = box.get(_themeKey, defaultValue: 0);
      state = ThemeMode.values[themeIndex];
    } catch (e) {
      print('Error loading theme: $e');
      state = ThemeMode.system;
    }
  }

  // Save theme preference to Hive storage
  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final box = await Hive.openBox(_themeBoxName);
      await box.put(_themeKey, themeMode.index);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  // Set theme to light mode
  void setLightTheme() {
    state = ThemeMode.light;
    _saveTheme(ThemeMode.light);
  }

  // Set theme to dark mode
  void setDarkTheme() {
    state = ThemeMode.dark;
    _saveTheme(ThemeMode.dark);
  }

  // Set theme to system mode (follows device setting)
  void setSystemTheme() {
    state = ThemeMode.system;
    _saveTheme(ThemeMode.system);
  }

  // Toggle between light and dark themes
  void toggleTheme() {
    switch (state) {
      case ThemeMode.light:
        setDarkTheme();
        break;
      case ThemeMode.dark:
        setLightTheme();
        break;
      case ThemeMode.system:
        // If system theme, toggle to opposite of current brightness
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        if (brightness == Brightness.dark) {
          setLightTheme();
        } else {
          setDarkTheme();
        }
        break;
    }
  }

  // Get current theme mode as string for display
  String get themeDisplayName {
    switch (state) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  // Check if current theme is dark
  bool get isDarkMode {
    switch (state) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark;
    }
  }
}

// Provider for theme management
final themeProvider = StateNotifierProvider<ThemeProvider, ThemeMode>((ref) {
  return ThemeProvider();
});

// Helper extension for theme mode
extension ThemeModeExtension on ThemeMode {
  IconData get icon {
    switch (this) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_brightness;
    }
  }

  String get displayName {
    switch (this) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}