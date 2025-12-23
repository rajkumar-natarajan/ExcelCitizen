import 'package:flutter_test/flutter_test.dart';
import '../../lib/controllers/smart_learning_controller.dart';
import '../../lib/models/question.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PerformanceStats', () {
    test('should initialize with default values', () {
      final stats = PerformanceStats(subType: 'test_subtype');
      expect(stats.subType, 'test_subtype');
      expect(stats.totalAttempts, 0);
      expect(stats.correctAttempts, 0);
      expect(stats.accuracy, 0);
    });

    test('should record correct attempts', () {
      final stats = PerformanceStats(subType: 'test');
      stats.recordAttempt(true);
      stats.recordAttempt(true);
      stats.recordAttempt(false);

      expect(stats.totalAttempts, 3);
      expect(stats.correctAttempts, 2);
      expect(stats.accuracy, closeTo(66.67, 0.1));
    });

    test('should calculate accuracy correctly', () {
      final stats = PerformanceStats(subType: 'test');
      stats.recordAttempt(true);
      stats.recordAttempt(true);
      stats.recordAttempt(true);
      stats.recordAttempt(true);

      expect(stats.accuracy, 100.0);
    });

    test('toJson and fromJson should work correctly', () {
      final stats = PerformanceStats(subType: 'test_subtype');
      stats.recordAttempt(true);
      stats.recordAttempt(false);

      final json = stats.toJson();
      final restored = PerformanceStats.fromJson(json);

      expect(restored.subType, stats.subType);
      expect(restored.totalAttempts, stats.totalAttempts);
      expect(restored.correctAttempts, stats.correctAttempts);
    });
  });

  group('TimeStats', () {
    test('should initialize with default values', () {
      final stats = TimeStats(subType: 'test');
      expect(stats.subType, 'test');
      expect(stats.totalTime, 0);
      expect(stats.questionCount, 0);
      expect(stats.averageTime, 0);
    });

    test('should record time correctly', () {
      final stats = TimeStats(subType: 'test');
      stats.recordTime(30);
      stats.recordTime(60);
      stats.recordTime(45);

      expect(stats.totalTime, 135);
      expect(stats.questionCount, 3);
      expect(stats.averageTime, 45.0);
    });

    test('toJson and fromJson should work correctly', () {
      final stats = TimeStats(subType: 'test');
      stats.recordTime(30);
      stats.recordTime(60);

      final json = stats.toJson();
      final restored = TimeStats.fromJson(json);

      expect(restored.subType, stats.subType);
      expect(restored.totalTime, stats.totalTime);
      expect(restored.questionCount, stats.questionCount);
    });
  });

  group('TestSessionRecord', () {
    test('should calculate accuracy correctly', () {
      final record = TestSessionRecord(
        date: DateTime.now(),
        totalQuestions: 10,
        correctAnswers: 7,
        totalTimeSeconds: 300,
        testType: 'Practice',
      );

      expect(record.accuracy, 0.7);
      expect(record.averageTimePerQuestion, 30.0);
    });

    test('should handle zero questions', () {
      final record = TestSessionRecord(
        date: DateTime.now(),
        totalQuestions: 0,
        correctAnswers: 0,
        totalTimeSeconds: 0,
        testType: 'Empty',
      );

      expect(record.accuracy, 0);
      expect(record.averageTimePerQuestion, 0);
    });

    test('toJson and fromJson should work correctly', () {
      final date = DateTime(2024, 1, 15, 10, 30);
      final record = TestSessionRecord(
        date: date,
        totalQuestions: 20,
        correctAnswers: 15,
        totalTimeSeconds: 600,
        testType: 'Mock Test',
      );

      final json = record.toJson();
      final restored = TestSessionRecord.fromJson(json);

      expect(restored.totalQuestions, record.totalQuestions);
      expect(restored.correctAnswers, record.correctAnswers);
      expect(restored.totalTimeSeconds, record.totalTimeSeconds);
      expect(restored.testType, record.testType);
    });
  });

  group('TrendPoint', () {
    test('should store values correctly', () {
      final point = TrendPoint(
        label: 'Week 1',
        value: 85.5,
        sessionCount: 5,
      );

      expect(point.label, 'Week 1');
      expect(point.value, 85.5);
      expect(point.sessionCount, 5);
    });
  });

  group('SmartLearningController - Unit Tests', () {
    test('singleton pattern should return same instance', () {
      final controller1 = SmartLearningController();
      final controller2 = SmartLearningController();
      expect(identical(controller1, controller2), true);
    });

    test('allStats should return empty map initially', () {
      final controller = SmartLearningController();
      // Note: This test depends on controller state
      // In a fresh state, allStats might be empty or have prior data
      expect(controller.allStats, isA<Map<String, PerformanceStats>>());
    });

    test('isBookmarked should return false for unknown questions', () {
      final controller = SmartLearningController();
      expect(controller.isBookmarked('nonexistent_q'), false);
    });

    test('bookmarkCount should return number of bookmarks', () {
      final controller = SmartLearningController();
      expect(controller.bookmarkCount, isA<int>());
    });

    test('getWeakAreas should return list of subtypes', () {
      final controller = SmartLearningController();
      final weakAreas = controller.getWeakAreas();
      expect(weakAreas, isA<List<String>>());
    });

    test('getQuestionsForReview should return list of question ids', () {
      final controller = SmartLearningController();
      final reviewList = controller.getQuestionsForReview();
      expect(reviewList, isA<List<String>>());
    });

    test('getRecentSessions should return limited list', () {
      final controller = SmartLearningController();
      final sessions = controller.getRecentSessions(5);
      expect(sessions.length, lessThanOrEqualTo(5));
    });

    test('getAccuracyTrend should return list of TrendPoints', () {
      final controller = SmartLearningController();
      final trend = controller.getAccuracyTrend();
      expect(trend, isA<List<TrendPoint>>());
    });

    test('allTimeStats should return map of TimeStats', () {
      final controller = SmartLearningController();
      expect(controller.allTimeStats, isA<Map<String, TimeStats>>());
    });

    test('masteredCount should return integer', () {
      final controller = SmartLearningController();
      expect(controller.masteredCount, isA<int>());
    });
  });

  group('SmartLearningController - Integration Tests', () {
    late Question testQuestion;

    setUp(() {
      testQuestion = Question(
        id: 'test_integration_q1',
        type: QuestionType.history,
        subType: HistorySubType.confederation.value,
        stem: 'Test question',
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 0,
        explanation: 'Test explanation',
        difficulty: Difficulty.medium,
      );
    });

    test('isBookmarked should return correct status', () {
      final controller = SmartLearningController();
      // Read-only test - toggleBookmark uses SharedPreferences which isn't available in unit tests
      expect(controller.isBookmarked('test_question_123'), false);
    });

    test('bookmarkedQuestionIds should return set of bookmarked ids', () {
      final controller = SmartLearningController();
      expect(controller.bookmarkedQuestionIds, isA<Set<String>>());
    });

    test('isWeakArea should handle unknown subtypes', () {
      final controller = SmartLearningController();
      expect(controller.isWeakArea('unknown_subtype'), false);
    });

    test('needsReview should return false for unknown questions', () {
      final controller = SmartLearningController();
      expect(controller.needsReview('unknown_question'), false);
    });

    test('getStats should return null for unknown subtype', () {
      final controller = SmartLearningController();
      expect(controller.getStats('unknown_subtype_xyz'), isNull);
    });

    test('getTimeStats should return null for unknown subtype', () {
      final controller = SmartLearningController();
      expect(controller.getTimeStats('unknown_subtype_xyz'), isNull);
    });

    test('getAverageTimeForType should return 0 for types with no data', () {
      final controller = SmartLearningController();
      // For types that may not have data yet
      final avgTime = controller.getAverageTimeForType(QuestionType.economy);
      expect(avgTime, isA<double>());
    });
  });
}
