// Question models for ExcelCitizen Flutter App
// Based on Canadian Citizenship Test structure (Discover Canada guide)

/// Question categories matching Citizenship Test topics
enum QuestionType {
  rightsResponsibilities('rights', 'Rights & Responsibilities'),
  history('history', 'Canadian History'),
  government('government', 'Government & Democracy'),
  geography('geography', 'Geography & Regions'),
  symbols('symbols', 'Canadian Symbols'),
  economy('economy', 'Economy & Industries');

  final String value;
  final String displayName;
  const QuestionType(this.value, this.displayName);
}

/// Rights & Responsibilities subtypes
enum RightsSubType {
  citizenshipRights('citizenship_rights', 'Citizenship Rights'),
  responsibilities('responsibilities', 'Responsibilities'),
  charterOfRights('charter', 'Charter of Rights'),
  equality('equality', 'Equality Rights');

  final String value;
  final String displayName;
  const RightsSubType(this.value, this.displayName);
}

/// History subtypes
enum HistorySubType {
  aboriginal('aboriginal', 'Aboriginal Peoples'),
  exploration('exploration', 'Exploration & Settlement'),
  confederation('confederation', 'Confederation'),
  modernCanada('modern', 'Modern Canada'),
  worldWars('world_wars', 'World Wars');

  final String value;
  final String displayName;
  const HistorySubType(this.value, this.displayName);
}

/// Government subtypes
enum GovernmentSubType {
  federalGovernment('federal', 'Federal Government'),
  provincialGovernment('provincial', 'Provincial/Territorial'),
  municipalGovernment('municipal', 'Municipal Government'),
  elections('elections', 'Elections & Voting'),
  monarchy('monarchy', 'Constitutional Monarchy');

  final String value;
  final String displayName;
  const GovernmentSubType(this.value, this.displayName);
}

/// Geography subtypes
enum GeographySubType {
  provinces('provinces', 'Provinces & Territories'),
  capitals('capitals', 'Capital Cities'),
  regions('regions', 'Regions of Canada'),
  naturalResources('resources', 'Natural Resources');

  final String value;
  final String displayName;
  const GeographySubType(this.value, this.displayName);
}

/// Symbols subtypes
enum SymbolsSubType {
  nationalSymbols('national', 'National Symbols'),
  holidays('holidays', 'National Holidays'),
  anthem('anthem', 'National Anthem'),
  flags('flags', 'Flags & Emblems');

  final String value;
  final String displayName;
  const SymbolsSubType(this.value, this.displayName);
}

/// Test difficulty levels
enum Difficulty {
  easy('easy', 'Easy'),
  medium('medium', 'Medium'),
  hard('hard', 'Hard');

  final String value;
  final String displayName;
  const Difficulty(this.value, this.displayName);
}

/// Supported languages
enum Language {
  english('en', 'English', '🇨🇦'),
  french('fr', 'Français', '🇨🇦');

  final String code;
  final String displayName;
  final String flag;
  const Language(this.code, this.displayName, this.flag);
}

/// Test types
enum TestType {
  quickAssessment('quick_assessment', 'Quick Assessment', 10, 5),
  standardPractice('standard_practice', 'Standard Practice', 20, 15),
  fullMock('full_mock', 'Full Mock Test', 20, 30),
  customTest('custom_test', 'Custom Test', 15, 15);

  final String value;
  final String displayName;
  final int defaultQuestionCount;
  final int defaultTimeMinutes;
  const TestType(this.value, this.displayName, this.defaultQuestionCount, this.defaultTimeMinutes);
}

/// Main Question model
class Question {
  final String id;
  final QuestionType type;
  final String subType;
  final String stem;
  final String stemFrench;
  final List<String> options;
  final List<String> optionsFrench;
  final int correctAnswer;
  final String explanation;
  final String explanationFrench;
  final Difficulty difficulty;
  final String? imageAsset;

  Question({
    required this.id,
    required this.type,
    required this.subType,
    required this.stem,
    String? stemFrench,
    required this.options,
    List<String>? optionsFrench,
    required this.correctAnswer,
    required this.explanation,
    String? explanationFrench,
    required this.difficulty,
    this.imageAsset,
  }) : stemFrench = stemFrench ?? stem,
       optionsFrench = optionsFrench ?? options,
       explanationFrench = explanationFrench ?? explanation;

  String getStem(Language language) =>
      language == Language.french ? stemFrench : stem;

  List<String> getOptions(Language language) =>
      language == Language.french ? optionsFrench : options;

  String getExplanation(Language language) =>
      language == Language.french ? explanationFrench : explanation;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.value,
        'subType': subType,
        'stem': stem,
        'stemFrench': stemFrench,
        'options': options,
        'optionsFrench': optionsFrench,
        'correctAnswer': correctAnswer,
        'explanation': explanation,
        'explanationFrench': explanationFrench,
        'difficulty': difficulty.value,
        'imageAsset': imageAsset,
      };

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      type: QuestionType.values.firstWhere(
        (t) => t.value == json['type'],
        orElse: () => QuestionType.history,
      ),
      subType: json['subType'] ?? '',
      stem: json['stem'] ?? '',
      stemFrench: json['stemFrench'] ?? json['stem'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      optionsFrench: List<String>.from(json['optionsFrench'] ?? json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? 0,
      explanation: json['explanation'] ?? '',
      explanationFrench: json['explanationFrench'] ?? json['explanation'] ?? '',
      difficulty: Difficulty.values.firstWhere(
        (d) => d.value == json['difficulty'],
        orElse: () => Difficulty.medium,
      ),
      imageAsset: json['imageAsset'],
    );
  }
}

/// Test configuration
class TestConfiguration {
  final TestType testType;
  final Difficulty? difficulty;
  final int questionCount;
  final int timeInMinutes;
  final List<QuestionType>? selectedTypes;
  final List<String>? selectedSubTypes;
  final bool shuffleQuestions;

  TestConfiguration({
    required this.testType,
    this.difficulty,
    int? questionCount,
    int? timeInMinutes,
    this.selectedTypes,
    this.selectedSubTypes,
    this.shuffleQuestions = true,
  })  : questionCount = questionCount ?? testType.defaultQuestionCount,
        timeInMinutes = timeInMinutes ?? testType.defaultTimeMinutes;

  TestConfiguration copyWith({
    TestType? testType,
    Difficulty? difficulty,
    int? questionCount,
    int? timeInMinutes,
    List<QuestionType>? selectedTypes,
    List<String>? selectedSubTypes,
    bool? shuffleQuestions,
  }) {
    return TestConfiguration(
      testType: testType ?? this.testType,
      difficulty: difficulty ?? this.difficulty,
      questionCount: questionCount ?? this.questionCount,
      timeInMinutes: timeInMinutes ?? this.timeInMinutes,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      selectedSubTypes: selectedSubTypes ?? this.selectedSubTypes,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
    );
  }
}

/// User answer for a question
class UserAnswer {
  final String questionId;
  final int selectedOption;
  final bool isCorrect;
  final Duration timeTaken;

  UserAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
    required this.timeTaken,
  });

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'selectedOption': selectedOption,
        'isCorrect': isCorrect,
        'timeTaken': timeTaken.inMilliseconds,
      };

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionId: json['questionId'] ?? '',
      selectedOption: json['selectedOption'] ?? -1,
      isCorrect: json['isCorrect'] ?? false,
      timeTaken: Duration(milliseconds: json['timeTaken'] ?? 0),
    );
  }
}

/// Test session result
class TestResult {
  final String id;
  final DateTime completedAt;
  final TestConfiguration configuration;
  final List<UserAnswer> answers;
  final int totalQuestions;
  final int correctAnswers;
  final Duration totalTime;
  final Map<QuestionType, int> scoreByType;
  final Map<String, int> scoreBySubType;

  TestResult({
    required this.id,
    required this.completedAt,
    required this.configuration,
    required this.answers,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalTime,
    required this.scoreByType,
    required this.scoreBySubType,
  });

  double get percentage =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

  // Passing score for citizenship test is 75%
  bool get passed => percentage >= 75;

  int get percentile {
    if (percentage >= 99) return 99;
    if (percentage >= 95) return 95;
    if (percentage >= 90) return 90;
    if (percentage >= 85) return 85;
    if (percentage >= 80) return 75;
    if (percentage >= 75) return 70;
    if (percentage >= 70) return 60;
    if (percentage >= 60) return 45;
    if (percentage >= 50) return 30;
    return 15;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'completedAt': completedAt.toIso8601String(),
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'totalTime': totalTime.inMilliseconds,
        'answers': answers.map((a) => a.toJson()).toList(),
        'scoreByType': scoreByType.map((k, v) => MapEntry(k.value, v)),
        'scoreBySubType': scoreBySubType,
      };
}

/// User progress tracking
class UserProgress {
  final int totalQuestionsAttempted;
  final int totalCorrect;
  final Map<QuestionType, int> correctPerType;
  final List<TestResult> recentTests;
  final DateTime lastPracticeDate;
  final int currentStreak;
  final int longestStreak;

  UserProgress({
    this.totalQuestionsAttempted = 0,
    this.totalCorrect = 0,
    this.correctPerType = const {},
    this.recentTests = const [],
    DateTime? lastPracticeDate,
    this.currentStreak = 0,
    this.longestStreak = 0,
  }) : lastPracticeDate = lastPracticeDate ?? DateTime.now();

  double get accuracy =>
      totalQuestionsAttempted > 0
          ? (totalCorrect / totalQuestionsAttempted) * 100
          : 0;

  Map<String, dynamic> toJson() => {
        'totalQuestionsAttempted': totalQuestionsAttempted,
        'totalCorrect': totalCorrect,
        'correctPerType': correctPerType.map((k, v) => MapEntry(k.value, v)),
        'lastPracticeDate': lastPracticeDate.toIso8601String(),
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
      };
}
