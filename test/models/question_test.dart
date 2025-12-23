import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/question.dart';

void main() {
  group('QuestionType', () {
    test('should have correct values and display names', () {
      expect(QuestionType.rightsResponsibilities.value, 'rights');
      expect(QuestionType.rightsResponsibilities.displayName, 'Rights & Responsibilities');
      expect(QuestionType.history.value, 'history');
      expect(QuestionType.history.displayName, 'Canadian History');
      expect(QuestionType.government.value, 'government');
      expect(QuestionType.geography.value, 'geography');
      expect(QuestionType.symbols.value, 'symbols');
      expect(QuestionType.economy.value, 'economy');
    });

    test('should have 6 question types', () {
      expect(QuestionType.values.length, 6);
    });
  });

  group('Difficulty', () {
    test('should have correct values and display names', () {
      expect(Difficulty.easy.value, 'easy');
      expect(Difficulty.easy.displayName, 'Easy');
      expect(Difficulty.medium.value, 'medium');
      expect(Difficulty.medium.displayName, 'Medium');
      expect(Difficulty.hard.value, 'hard');
      expect(Difficulty.hard.displayName, 'Hard');
    });

    test('should have 3 difficulty levels', () {
      expect(Difficulty.values.length, 3);
    });
  });

  group('Language', () {
    test('should have correct properties', () {
      expect(Language.english.code, 'en');
      expect(Language.english.displayName, 'English');
      expect(Language.french.code, 'fr');
      expect(Language.french.displayName, 'Français');
    });

    test('should have 2 languages', () {
      expect(Language.values.length, 2);
    });
  });

  group('TestType', () {
    test('should have correct default values', () {
      expect(TestType.quickAssessment.defaultQuestionCount, 10);
      expect(TestType.quickAssessment.defaultTimeMinutes, 5);
      expect(TestType.standardPractice.defaultQuestionCount, 20);
      expect(TestType.standardPractice.defaultTimeMinutes, 15);
      expect(TestType.fullMock.defaultQuestionCount, 20);
      expect(TestType.fullMock.defaultTimeMinutes, 30);
    });
  });

  group('Question', () {
    late Question question;

    setUp(() {
      question = Question(
        id: 'test_q1',
        type: QuestionType.history,
        subType: 'confederation',
        stem: 'What year was Canada established?',
        stemFrench: 'En quelle année le Canada a-t-il été fondé?',
        options: ['1867', '1776', '1900', '1812'],
        optionsFrench: ['1867', '1776', '1900', '1812'],
        correctAnswer: 0,
        explanation: 'Canada was established in 1867 through Confederation.',
        explanationFrench: 'Le Canada a été fondé en 1867 par la Confédération.',
        difficulty: Difficulty.medium,
      );
    });

    test('should create question with required properties', () {
      expect(question.id, 'test_q1');
      expect(question.type, QuestionType.history);
      expect(question.subType, 'confederation');
      expect(question.stem, 'What year was Canada established?');
      expect(question.options.length, 4);
      expect(question.correctAnswer, 0);
      expect(question.difficulty, Difficulty.medium);
    });

    test('getStem should return correct language version', () {
      expect(question.getStem(Language.english), 'What year was Canada established?');
      expect(question.getStem(Language.french), 'En quelle année le Canada a-t-il été fondé?');
    });

    test('getOptions should return correct language version', () {
      final englishOptions = question.getOptions(Language.english);
      final frenchOptions = question.getOptions(Language.french);
      expect(englishOptions, question.options);
      expect(frenchOptions, question.optionsFrench);
    });

    test('getExplanation should return correct language version', () {
      expect(question.getExplanation(Language.english), contains('1867'));
      expect(question.getExplanation(Language.french), contains('Confédération'));
    });

    test('should default French text to English if not provided', () {
      final questionEnglishOnly = Question(
        id: 'test_q2',
        type: QuestionType.geography,
        subType: 'provinces',
        stem: 'What is the capital of Canada?',
        options: ['Ottawa', 'Toronto', 'Vancouver', 'Montreal'],
        correctAnswer: 0,
        explanation: 'Ottawa is the capital of Canada.',
        difficulty: Difficulty.easy,
      );

      expect(questionEnglishOnly.stemFrench, 'What is the capital of Canada?');
      expect(questionEnglishOnly.optionsFrench, questionEnglishOnly.options);
      expect(questionEnglishOnly.explanationFrench, questionEnglishOnly.explanation);
    });

    test('toJson should serialize correctly', () {
      final json = question.toJson();
      expect(json['id'], 'test_q1');
      expect(json['type'], 'history');
      expect(json['subType'], 'confederation');
      expect(json['correctAnswer'], 0);
      expect(json['difficulty'], 'medium');
    });

    test('fromJson should deserialize correctly', () {
      final json = {
        'id': 'test_q3',
        'type': 'government',
        'subType': 'federal',
        'stem': 'Who is the head of state?',
        'options': ['The Monarch', 'The Prime Minister', 'The Premier', 'The Mayor'],
        'correctAnswer': 0,
        'explanation': 'The Monarch is the head of state.',
        'difficulty': 'hard',
      };

      final parsedQuestion = Question.fromJson(json);
      expect(parsedQuestion.id, 'test_q3');
      expect(parsedQuestion.type, QuestionType.government);
      expect(parsedQuestion.subType, 'federal');
      expect(parsedQuestion.difficulty, Difficulty.hard);
    });

    test('fromJson should handle missing fields gracefully', () {
      final json = <String, dynamic>{};
      final parsedQuestion = Question.fromJson(json);
      expect(parsedQuestion.id, '');
      expect(parsedQuestion.type, QuestionType.history); // default
      expect(parsedQuestion.difficulty, Difficulty.medium); // default
    });
  });

  group('TestConfiguration', () {
    test('should use default values from TestType', () {
      final config = TestConfiguration(testType: TestType.quickAssessment);
      expect(config.questionCount, 10);
      expect(config.timeInMinutes, 5);
      expect(config.shuffleQuestions, true);
    });

    test('should allow custom values', () {
      final config = TestConfiguration(
        testType: TestType.customTest,
        questionCount: 25,
        timeInMinutes: 20,
        difficulty: Difficulty.hard,
        shuffleQuestions: false,
      );
      expect(config.questionCount, 25);
      expect(config.timeInMinutes, 20);
      expect(config.difficulty, Difficulty.hard);
      expect(config.shuffleQuestions, false);
    });

    test('copyWith should create a new instance with updated values', () {
      final original = TestConfiguration(testType: TestType.standardPractice);
      final copied = original.copyWith(
        questionCount: 30,
        difficulty: Difficulty.easy,
      );

      expect(copied.questionCount, 30);
      expect(copied.difficulty, Difficulty.easy);
      expect(copied.testType, original.testType);
      expect(copied.timeInMinutes, original.timeInMinutes);
    });

    test('should accept selected types filter', () {
      final config = TestConfiguration(
        testType: TestType.standardPractice,
        selectedTypes: [QuestionType.history, QuestionType.geography],
      );
      expect(config.selectedTypes?.length, 2);
      expect(config.selectedTypes, contains(QuestionType.history));
    });
  });

  group('UserAnswer', () {
    test('should create correctly', () {
      final answer = UserAnswer(
        questionId: 'q1',
        selectedOption: 2,
        isCorrect: true,
        timeTaken: const Duration(seconds: 30),
      );

      expect(answer.questionId, 'q1');
      expect(answer.selectedOption, 2);
      expect(answer.isCorrect, true);
      expect(answer.timeTaken.inSeconds, 30);
    });
  });

  group('SubType Enums', () {
    test('RightsSubType should have correct values', () {
      expect(RightsSubType.citizenshipRights.value, 'citizenship_rights');
      expect(RightsSubType.charterOfRights.value, 'charter');
      expect(RightsSubType.values.length, 4);
    });

    test('HistorySubType should have correct values', () {
      expect(HistorySubType.aboriginal.value, 'aboriginal');
      expect(HistorySubType.confederation.value, 'confederation');
      expect(HistorySubType.worldWars.value, 'world_wars');
      expect(HistorySubType.values.length, 5);
    });

    test('GovernmentSubType should have correct values', () {
      expect(GovernmentSubType.federalGovernment.value, 'federal');
      expect(GovernmentSubType.elections.value, 'elections');
      expect(GovernmentSubType.values.length, 4);
    });

    test('GeographySubType should have correct values', () {
      expect(GeographySubType.provinces.value, 'provinces');
      expect(GeographySubType.capitals.value, 'capitals');
      expect(GeographySubType.values.length, 4);
    });

    test('SymbolsSubType should have correct values', () {
      expect(SymbolsSubType.nationalSymbols.value, 'national');
      expect(SymbolsSubType.holidays.value, 'holidays');
      expect(SymbolsSubType.values.length, 4);
    });
  });
}
