import 'package:doctor_appointment/core/resources/theme.dart';
import 'package:flutter/material.dart';

enum ThemeModeState {
  lightTheme,
  darkTheme,
  system
}

class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  late ThemeMode currentThemeMode;
  late ThemeModeState _requestTheme;

  ThemeNotifier([ThemeModeState initialTheme = ThemeModeState.system]): _requestTheme = initialTheme {
    Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    currentThemeMode = _getThemeBaseOnBrightness(brightness);
    WidgetsBinding.instance.addObserver(this);
  }

  void setThemeMode(ThemeModeState themeMode) {
    if (themeMode == _requestTheme) return;

    _requestTheme = themeMode;
    if (_requestTheme == ThemeModeState.lightTheme) {
      currentThemeMode = ThemeMode.light;
    } else if (_requestTheme == ThemeModeState.darkTheme) {
      currentThemeMode = ThemeMode.dark;
    } else {
      Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      currentThemeMode = _getThemeBaseOnBrightness(brightness);
    }

    notifyListeners();
  }

  get lightTheme => AppTheme.lightTheme;
  get darkTheme => AppTheme.darkTheme;

  @override
  void didChangePlatformBrightness() {
    if (_requestTheme == ThemeModeState.system) {
      Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      currentThemeMode = _getThemeBaseOnBrightness(brightness);

      notifyListeners();
    }
  }

  ThemeMode _getThemeBaseOnBrightness(Brightness brightness) {
    if (brightness == Brightness.light) {
      return ThemeMode.light;
    } else if (brightness == Brightness.dark) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}