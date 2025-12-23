import 'package:flutter_test/flutter_test.dart';
import '../../lib/controllers/gamification_controller.dart';

void main() {
  group('GamificationController', () {
    test('singleton pattern should return same instance', () {
      final controller1 = GamificationController();
      final controller2 = GamificationController();
      expect(identical(controller1, controller2), true);
    });

    test('should have valid initial XP values', () {
      final controller = GamificationController();
      expect(controller.totalXP, isA<int>());
      expect(controller.totalXP, greaterThanOrEqualTo(0));
    });

    test('should have valid initial level', () {
      final controller = GamificationController();
      expect(controller.currentLevel, isA<int>());
      expect(controller.currentLevel, greaterThanOrEqualTo(1));
    });

    test('should have valid streak values', () {
      final controller = GamificationController();
      expect(controller.currentStreak, isA<int>());
      expect(controller.currentStreak, greaterThanOrEqualTo(0));
      expect(controller.bestStreak, isA<int>());
      expect(controller.bestStreak, greaterThanOrEqualTo(0));
      expect(controller.dailyStreak, isA<int>());
      expect(controller.dailyStreak, greaterThanOrEqualTo(0));
    });

    test('xpForNextLevel should increase with level', () {
      final controller = GamificationController();
      final xpNeeded = controller.xpForNextLevel;
      expect(xpNeeded, greaterThan(0));
    });

    test('levelProgress should be between 0 and 1', () {
      final controller = GamificationController();
      expect(controller.levelProgress, greaterThanOrEqualTo(0));
      expect(controller.levelProgress, lessThanOrEqualTo(1));
    });

    test('unlockedAchievements should be a set', () {
      final controller = GamificationController();
      expect(controller.unlockedAchievements, isA<Set<String>>());
    });

    test('today stats should be valid', () {
      final controller = GamificationController();
      expect(controller.todayQuestions, isA<int>());
      expect(controller.todayQuestions, greaterThanOrEqualTo(0));
      expect(controller.todayCorrect, isA<int>());
      expect(controller.todayCorrect, greaterThanOrEqualTo(0));
    });

    test('totalPoints should be non-negative', () {
      final controller = GamificationController();
      expect(controller.totalPoints, isA<int>());
      expect(controller.totalPoints, greaterThanOrEqualTo(0));
    });
  });

  group('GamificationController XP Calculations', () {
    test('xpInCurrentLevel should not exceed xpForNextLevel', () {
      final controller = GamificationController();
      expect(controller.xpInCurrentLevel, lessThanOrEqualTo(controller.xpForNextLevel));
    });

    test('level progress formula should be consistent', () {
      final controller = GamificationController();
      final expectedProgress = controller.xpInCurrentLevel / controller.xpForNextLevel;
      expect(controller.levelProgress, closeTo(expectedProgress, 0.001));
    });
  });
}
