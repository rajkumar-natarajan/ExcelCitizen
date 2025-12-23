import 'package:flutter/material.dart';
import '../models/question.dart';

class SettingsController with ChangeNotifier {
  static final SettingsController _instance = SettingsController._internal();
  factory SettingsController() => _instance;
  SettingsController._internal();

  ThemeMode _themeMode = ThemeMode.system;
  Language _language = Language.english;
  CitizenshipLevel _defaultLevel = CitizenshipLevel.level12;

  ThemeMode get themeMode => _themeMode;
  Language get language => _language;
  CitizenshipLevel get defaultLevel => _defaultLevel;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setLanguage(Language language) {
    _language = language;
    notifyListeners();
  }

  void setLevel(CitizenshipLevel level) {
    _defaultLevel = level;
    notifyListeners();
  }
}
