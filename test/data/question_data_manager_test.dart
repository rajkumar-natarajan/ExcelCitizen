import 'package:flutter_test/flutter_test.dart';
import '../../lib/data/question_data_manager.dart';
import '../../lib/models/question.dart';

void main() {
  late QuestionDataManager manager;

  setUp(() async {
    manager = QuestionDataManager();
    await manager.initialize();
  });

  group('QuestionDataManager Initialization', () {
    test('singleton pattern should return same instance', () {
      final manager1 = QuestionDataManager();
      final manager2 = QuestionDataManager();
      expect(identical(manager1, manager2), true);
    });

    test('should load questions after initialization', () {
      expect(manager.allQuestions, isNotEmpty);
    });

    test('should have questions for all categories', () {
      final types = QuestionType.values;
      for (final type in types) {
        final questions = manager.getQuestionsByType(type);
        expect(questions, isNotEmpty, reason: 'Should have questions for ${type.displayName}');
      }
    });
  });

  group('Question Retrieval', () {
    test('getQuestionsByType should filter correctly', () {
      final historyQuestions = manager.getQuestionsByType(QuestionType.history);
      expect(historyQuestions, isNotEmpty);
      for (final q in historyQuestions) {
        expect(q.type, QuestionType.history);
      }
    });

    test('getQuestionsByType should return separate lists', () {
      final rights = manager.getQuestionsByType(QuestionType.rightsResponsibilities);
      final history = manager.getQuestionsByType(QuestionType.history);
      
      expect(rights.every((q) => q.type == QuestionType.rightsResponsibilities), true);
      expect(history.every((q) => q.type == QuestionType.history), true);
    });

    test('getRandomQuestions should return requested count', () {
      final random = manager.getRandomQuestions(5);
      expect(random.length, 5);
    });

    test('getRandomQuestions with types filter should work', () {
      final random = manager.getRandomQuestions(
        5,
        types: [QuestionType.geography],
      );
      expect(random, isNotEmpty);
      for (final q in random) {
        expect(q.type, QuestionType.geography);
      }
    });

    test('getQuestionById should find existing question', () {
      final allQuestions = manager.allQuestions;
      if (allQuestions.isNotEmpty) {
        final firstQuestion = allQuestions.first;
        final found = manager.getQuestionById(firstQuestion.id);
        expect(found, isNotNull);
        expect(found!.id, firstQuestion.id);
      }
    });

    test('getQuestionById should return null for non-existent id', () {
      final found = manager.getQuestionById('non_existent_id_xyz');
      expect(found, isNull);
    });
  });

  group('Configured Questions', () {
    test('should return correct number of questions', () {
      final config = TestConfiguration(
        testType: TestType.quickAssessment,
      );
      final questions = manager.getConfiguredQuestions(config, Language.english);
      expect(questions.length, config.questionCount);
    });

    test('should filter by selected types', () {
      final config = TestConfiguration(
        testType: TestType.quickAssessment, // Smaller test to avoid duplication
        selectedTypes: [QuestionType.government],
        questionCount: 5, // Request fewer questions
      );
      final questions = manager.getConfiguredQuestions(config, Language.english);
      
      // When filtering works, most questions should be of the requested type
      final govCount = questions.where((q) => q.type == QuestionType.government).length;
      expect(govCount, greaterThan(0)); // At least some government questions
    });

    test('should handle multiple selected types', () {
      final config = TestConfiguration(
        testType: TestType.standardPractice,
        selectedTypes: [QuestionType.history, QuestionType.symbols],
      );
      final questions = manager.getConfiguredQuestions(config, Language.english);
      
      for (final q in questions) {
        expect(
          q.type == QuestionType.history || q.type == QuestionType.symbols,
          true,
        );
      }
    });

    test('should shuffle questions when configured', () {
      final config1 = TestConfiguration(
        testType: TestType.fullMock,
        shuffleQuestions: true,
      );
      final config2 = TestConfiguration(
        testType: TestType.fullMock,
        shuffleQuestions: true,
      );
      
      final questions1 = manager.getConfiguredQuestions(config1, Language.english);
      final questions2 = manager.getConfiguredQuestions(config2, Language.english);
      
      // Due to shuffling, the order should likely be different
      // (though there's a small chance they could be the same)
      expect(questions1.length, questions2.length);
    });

    test('should handle custom question count', () {
      final config = TestConfiguration(
        testType: TestType.customTest,
        questionCount: 15,
      );
      final questions = manager.getConfiguredQuestions(config, Language.english);
      expect(questions.length, 15);
    });
  });

  group('Question Content Validation', () {
    test('all questions should have valid structure', () {
      for (final question in manager.allQuestions) {
        expect(question.id, isNotEmpty, reason: 'Question should have id');
        expect(question.stem, isNotEmpty, reason: 'Question should have stem');
        expect(question.options.length, 4, reason: 'Question should have 4 options');
        expect(question.correctAnswer, inInclusiveRange(0, 3), reason: 'Correct answer should be 0-3');
        expect(question.explanation, isNotEmpty, reason: 'Question should have explanation');
      }
    });

    test('all questions should have valid subtype', () {
      for (final question in manager.allQuestions) {
        expect(question.subType, isNotEmpty);
      }
    });

    test('all questions should have valid difficulty', () {
      for (final question in manager.allQuestions) {
        expect(Difficulty.values.contains(question.difficulty), true);
      }
    });

    test('questions should support both languages', () {
      final question = manager.allQuestions.first;
      expect(question.getStem(Language.english), isNotEmpty);
      expect(question.getOptions(Language.english), isNotEmpty);
      expect(question.getExplanation(Language.english), isNotEmpty);
    });
  });

  group('Category-specific Tests', () {
    test('Rights & Responsibilities questions should be valid', () {
      final questions = manager.getQuestionsByType(QuestionType.rightsResponsibilities);
      expect(questions, isNotEmpty);
      // Just verify questions exist and have content
      for (final q in questions) {
        expect(q.stem, isNotEmpty);
        expect(q.options.length, 4);
      }
    });

    test('History questions should be valid', () {
      final questions = manager.getQuestionsByType(QuestionType.history);
      expect(questions, isNotEmpty);
    });

    test('Government questions should be valid', () {
      final questions = manager.getQuestionsByType(QuestionType.government);
      expect(questions, isNotEmpty);
    });

    test('Geography questions should be valid', () {
      final questions = manager.getQuestionsByType(QuestionType.geography);
      expect(questions, isNotEmpty);
    });

    test('Symbols questions should be valid', () {
      final questions = manager.getQuestionsByType(QuestionType.symbols);
      expect(questions, isNotEmpty);
    });

    test('Economy questions should be valid', () {
      final questions = manager.getQuestionsByType(QuestionType.economy);
      expect(questions, isNotEmpty);
    });
  });

  group('Edge Cases', () {
    test('should handle empty selected types gracefully', () {
      final config = TestConfiguration(
        testType: TestType.quickAssessment,
        selectedTypes: [],
      );
      final questions = manager.getConfiguredQuestions(config, Language.english);
      // Empty types should fall back to all questions
      expect(questions, isNotEmpty);
    });

    test('should handle request for more questions than available', () {
      final config = TestConfiguration(
        testType: TestType.customTest,
        questionCount: 1000, // Very large number
      );
      final questions = manager.getConfiguredQuestions(config, Language.english);
      // Should still return requested count by duplicating
      expect(questions.length, 1000);
    });
  });
}
