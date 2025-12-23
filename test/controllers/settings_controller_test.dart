import 'package:flutter_test/flutter_test.dart';
import '../../lib/controllers/settings_controller.dart';
import '../../lib/models/question.dart';
import 'package:flutter/material.dart';

void main() {
  group('SettingsController', () {
    test('singleton pattern should return same instance', () {
      final controller1 = SettingsController();
      final controller2 = SettingsController();
      expect(identical(controller1, controller2), true);
    });

    test('should have default theme mode', () {
      final controller = SettingsController();
      expect(controller.themeMode, isA<ThemeMode>());
    });

    test('should have default language', () {
      final controller = SettingsController();
      expect(controller.language, isA<Language>());
    });

    test('should have default difficulty', () {
      final controller = SettingsController();
      expect(controller.defaultDifficulty, isA<Difficulty>());
    });

    test('toggleTheme should switch between dark and light', () {
      final controller = SettingsController();
      
      // Toggle to dark
      controller.toggleTheme(true);
      expect(controller.themeMode, ThemeMode.dark);
      
      // Toggle to light
      controller.toggleTheme(false);
      expect(controller.themeMode, ThemeMode.light);
    });

    test('setLanguage should update language', () {
      final controller = SettingsController();
      
      controller.setLanguage(Language.french);
      expect(controller.language, Language.french);
      
      controller.setLanguage(Language.english);
      expect(controller.language, Language.english);
    });

    test('setDifficulty should update difficulty', () {
      final controller = SettingsController();
      
      controller.setDifficulty(Difficulty.easy);
      expect(controller.defaultDifficulty, Difficulty.easy);
      
      controller.setDifficulty(Difficulty.hard);
      expect(controller.defaultDifficulty, Difficulty.hard);
      
      controller.setDifficulty(Difficulty.medium);
      expect(controller.defaultDifficulty, Difficulty.medium);
    });

    test('should notify listeners on theme change', () {
      final controller = SettingsController();
      bool notified = false;
      
      controller.addListener(() {
        notified = true;
      });
      
      controller.toggleTheme(true);
      expect(notified, true);
      
      controller.removeListener(() {});
    });

    test('should notify listeners on language change', () {
      final controller = SettingsController();
      bool notified = false;
      
      controller.addListener(() {
        notified = true;
      });
      
      controller.setLanguage(Language.french);
      expect(notified, true);
    });

    test('should notify listeners on difficulty change', () {
      final controller = SettingsController();
      bool notified = false;
      
      controller.addListener(() {
        notified = true;
      });
      
      controller.setDifficulty(Difficulty.hard);
      expect(notified, true);
    });
  });
}
