import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';

/// Manages smart learning features: weak areas, spaced repetition, bookmarks, time analytics
class SmartLearningController extends ChangeNotifier {
  static final SmartLearningController _instance = SmartLearningController._internal();
  factory SmartLearningController() => _instance;
  SmartLearningController._internal();

  // Performance tracking by question type and subtype
  Map<String, PerformanceStats> _performanceBySubType = {};
  
  // Bookmarked question IDs
  Set<String> _bookmarkedQuestions = {};
  
  // Questions answered incorrectly with timestamp for spaced repetition
  Map<String, DateTime> _incorrectQuestions = {};
  
  // Questions answered correctly (to exclude from weak area focus)
  Set<String> _masteredQuestions = {};
  
  // Time tracking per question subtype (in seconds)
  Map<String, TimeStats> _timeBySubType = {};
  
  // Test session history for trend analysis
  List<TestSessionRecord> _testHistory = [];

  bool _isInitialized = false;

  /// Initialize and load from storage
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    
    // Load performance stats
    final perfJson = prefs.getString('smart_learning_performance');
    if (perfJson != null) {
      final Map<String, dynamic> data = jsonDecode(perfJson);
      _performanceBySubType = data.map((key, value) => 
        MapEntry(key, PerformanceStats.fromJson(value)));
    }
    
    // Load bookmarks
    final bookmarks = prefs.getStringList('smart_learning_bookmarks');
    if (bookmarks != null) {
      _bookmarkedQuestions = bookmarks.toSet();
    }
    
    // Load incorrect questions
    final incorrectJson = prefs.getString('smart_learning_incorrect');
    if (incorrectJson != null) {
      final Map<String, dynamic> data = jsonDecode(incorrectJson);
      _incorrectQuestions = data.map((key, value) => 
        MapEntry(key, DateTime.parse(value)));
    }
    
    // Load mastered questions
    final mastered = prefs.getStringList('smart_learning_mastered');
    if (mastered != null) {
      _masteredQuestions = mastered.toSet();
    }
    
    // Load time stats
    final timeJson = prefs.getString('smart_learning_time_stats');
    if (timeJson != null) {
      final Map<String, dynamic> data = jsonDecode(timeJson);
      _timeBySubType = data.map((key, value) => 
        MapEntry(key, TimeStats.fromJson(value)));
    }
    
    // Load test history
    final historyJson = prefs.getString('smart_learning_test_history');
    if (historyJson != null) {
      final List<dynamic> data = jsonDecode(historyJson);
      _testHistory = data.map((e) => TestSessionRecord.fromJson(e)).toList();
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  /// Save all data to storage
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save performance stats
    final perfData = _performanceBySubType.map((key, value) => 
      MapEntry(key, value.toJson()));
    await prefs.setString('smart_learning_performance', jsonEncode(perfData));
    
    // Save bookmarks
    await prefs.setStringList('smart_learning_bookmarks', _bookmarkedQuestions.toList());
    
    // Save incorrect questions
    final incorrectData = _incorrectQuestions.map((key, value) => 
      MapEntry(key, value.toIso8601String()));
    await prefs.setString('smart_learning_incorrect', jsonEncode(incorrectData));
    
    // Save mastered questions
    await prefs.setStringList('smart_learning_mastered', _masteredQuestions.toList());
    
    // Save time stats
    final timeData = _timeBySubType.map((key, value) => 
      MapEntry(key, value.toJson()));
    await prefs.setString('smart_learning_time_stats', jsonEncode(timeData));
    
    // Save test history (keep last 50 sessions)
    final historyData = _testHistory.take(50).map((e) => e.toJson()).toList();
    await prefs.setString('smart_learning_test_history', jsonEncode(historyData));
  }

  // ==================== BOOKMARKS ====================

  bool isBookmarked(String questionId) => _bookmarkedQuestions.contains(questionId);

  void toggleBookmark(String questionId) {
    if (_bookmarkedQuestions.contains(questionId)) {
      _bookmarkedQuestions.remove(questionId);
    } else {
      _bookmarkedQuestions.add(questionId);
    }
    _save();
    notifyListeners();
  }

  Set<String> get bookmarkedQuestionIds => Set.from(_bookmarkedQuestions);
  
  int get bookmarkCount => _bookmarkedQuestions.length;

  // ==================== PERFORMANCE TRACKING ====================

  /// Record an answer for a question
  void recordAnswer(Question question, bool isCorrect, {int? timeSpentSeconds}) {
    final subType = question.subType;
    
    // Update performance stats
    if (!_performanceBySubType.containsKey(subType)) {
      _performanceBySubType[subType] = PerformanceStats(subType: subType);
    }
    _performanceBySubType[subType]!.recordAttempt(isCorrect);
    
    // Update time stats
    if (timeSpentSeconds != null && timeSpentSeconds > 0) {
      if (!_timeBySubType.containsKey(subType)) {
        _timeBySubType[subType] = TimeStats(subType: subType);
      }
      _timeBySubType[subType]!.recordTime(timeSpentSeconds);
    }
    
    // Update spaced repetition tracking
    if (isCorrect) {
      // If answered correctly twice, mark as mastered
      if (_incorrectQuestions.containsKey(question.id)) {
        _incorrectQuestions.remove(question.id);
        _masteredQuestions.add(question.id);
      }
    } else {
      // Track incorrect answer with timestamp
      _incorrectQuestions[question.id] = DateTime.now();
      _masteredQuestions.remove(question.id);
    }
    
    _save();
    notifyListeners();
  }

  /// Record multiple answers from a test session with timing
  void recordTestSessionWithTime(
    List<Question> questions, 
    List<UserAnswer> answers,
    int totalTimeSeconds,
  ) {
    int correct = 0;
    for (int i = 0; i < questions.length && i < answers.length; i++) {
      // Estimate time per question (can be enhanced with actual per-question timing)
      int estimatedTime = totalTimeSeconds ~/ questions.length;
      recordAnswer(questions[i], answers[i].isCorrect, timeSpentSeconds: estimatedTime);
      if (answers[i].isCorrect) correct++;
    }
    
    // Record test session for history
    _testHistory.insert(0, TestSessionRecord(
      date: DateTime.now(),
      totalQuestions: questions.length,
      correctAnswers: correct,
      totalTimeSeconds: totalTimeSeconds,
      level: questions.isNotEmpty ? questions.first.level.value : 'unknown',
    ));
    
    _save();
    notifyListeners();
  }

  /// Record multiple answers from a test session
  void recordTestSession(List<Question> questions, List<UserAnswer> answers) {
    for (int i = 0; i < questions.length && i < answers.length; i++) {
      recordAnswer(questions[i], answers[i].isCorrect);
    }
  }

  /// Get performance stats for a subtype
  PerformanceStats? getStats(String subType) => _performanceBySubType[subType];

  /// Get all performance stats
  Map<String, PerformanceStats> get allStats => Map.from(_performanceBySubType);

  // ==================== TIME ANALYTICS ====================

  /// Get time stats for a subtype
  TimeStats? getTimeStats(String subType) => _timeBySubType[subType];

  /// Get all time stats
  Map<String, TimeStats> get allTimeStats => Map.from(_timeBySubType);

  /// Get average time per question type
  double getAverageTimeForType(QuestionType type) {
    final subtypes = _getSubtypesForType(type);
    int totalTime = 0;
    int totalQuestions = 0;
    
    for (final subtype in subtypes) {
      if (_timeBySubType.containsKey(subtype)) {
        totalTime += _timeBySubType[subtype]!.totalTime;
        totalQuestions += _timeBySubType[subtype]!.questionCount;
      }
    }
    
    return totalQuestions > 0 ? totalTime / totalQuestions : 0;
  }

  List<String> _getSubtypesForType(QuestionType type) {
    switch (type) {
      case QuestionType.verbal:
        return [VerbalSubType.analogies.value, VerbalSubType.sentenceCompletion.value, 
                VerbalSubType.classification.value, VerbalSubType.synonyms.value,
                VerbalSubType.antonyms.value];
      case QuestionType.quantitative:
        return [QuantitativeSubType.numberAnalogies.value, QuantitativeSubType.numberSeries.value,
                QuantitativeSubType.quantitativeRelations.value];
      case QuestionType.nonVerbal:
        return [NonVerbalSubType.figureMatrices.value, NonVerbalSubType.figureClassification.value,
                NonVerbalSubType.figureSeries.value];
    }
  }

  // ==================== TEST HISTORY ====================

  /// Get test session history
  List<TestSessionRecord> get testHistory => List.from(_testHistory);

  /// Get recent test sessions (last n)
  List<TestSessionRecord> getRecentSessions(int count) => 
    _testHistory.take(count).toList();

  /// Get test sessions for the last n days
  List<TestSessionRecord> getSessionsForDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _testHistory.where((s) => s.date.isAfter(cutoff)).toList();
  }

  /// Get accuracy trend (weekly averages)
  List<TrendPoint> getAccuracyTrend() {
    final last30Days = getSessionsForDays(30);
    if (last30Days.isEmpty) return [];

    // Group by week
    Map<String, List<TestSessionRecord>> byWeek = {};
    for (final session in last30Days) {
      final weekKey = '${session.date.year}-W${_getWeekNumber(session.date)}';
      byWeek.putIfAbsent(weekKey, () => []);
      byWeek[weekKey]!.add(session);
    }

    // Calculate averages
    List<TrendPoint> trend = [];
    final sortedWeeks = byWeek.keys.toList()..sort();
    for (final week in sortedWeeks) {
      final sessions = byWeek[week]!;
      int totalQ = 0, totalCorrect = 0;
      for (final s in sessions) {
        totalQ += s.totalQuestions;
        totalCorrect += s.correctAnswers;
      }
      trend.add(TrendPoint(
        label: week,
        value: totalQ > 0 ? (totalCorrect / totalQ) * 100 : 0,
        sessionCount: sessions.length,
      ));
    }
    return trend;
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirst = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirst + firstDayOfYear.weekday) / 7).ceil();
  }

  /// Get daily practice count for the last n days
  List<TrendPoint> getDailyPracticeCount(int days) {
    final sessions = getSessionsForDays(days);
    Map<String, int> byDay = {};
    
    for (int i = 0; i < days; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = '${date.month}/${date.day}';
      byDay[key] = 0;
    }
    
    for (final session in sessions) {
      final key = '${session.date.month}/${session.date.day}';
      byDay[key] = (byDay[key] ?? 0) + 1;
    }
    
    return byDay.entries
        .map((e) => TrendPoint(label: e.key, value: e.value.toDouble(), sessionCount: e.value))
        .toList()
        .reversed
        .toList();
  }

  // ==================== WEAK AREA FOCUS ====================

  /// Get subtypes sorted by weakness (lowest accuracy first)
  List<String> getWeakAreas() {
    final sorted = _performanceBySubType.entries.toList()
      ..sort((a, b) => a.value.accuracy.compareTo(b.value.accuracy));
    return sorted.map((e) => e.key).toList();
  }

  /// Get the weakest subtypes (below 70% accuracy)
  List<String> getWeakSubTypes() {
    return _performanceBySubType.entries
        .where((e) => e.value.accuracy < 70 && e.value.totalAttempts >= 3)
        .map((e) => e.key)
        .toList();
  }

  /// Check if a subtype is a weak area
  bool isWeakArea(String subType) {
    final stats = _performanceBySubType[subType];
    if (stats == null || stats.totalAttempts < 3) return false;
    return stats.accuracy < 70;
  }

  // ==================== SPACED REPETITION ====================

  /// Get questions due for review (answered incorrectly and enough time has passed)
  List<String> getQuestionsForReview() {
    final now = DateTime.now();
    return _incorrectQuestions.entries
        .where((e) {
          final daysSinceIncorrect = now.difference(e.value).inDays;
          // Review after 1 day, then 3 days, then 7 days
          return daysSinceIncorrect >= 1;
        })
        .map((e) => e.key)
        .toList();
  }

  /// Check if a question needs review
  bool needsReview(String questionId) {
    if (!_incorrectQuestions.containsKey(questionId)) return false;
    final daysSince = DateTime.now().difference(_incorrectQuestions[questionId]!).inDays;
    return daysSince >= 1;
  }

  /// Get count of questions needing review
  int get reviewCount => getQuestionsForReview().length;

  // ==================== SMART QUESTION SELECTION ====================

  /// Prioritize questions based on smart learning
  /// - Questions needing review come first
  /// - Questions from weak areas come second
  /// - Exclude mastered questions (optional)
  List<Question> prioritizeQuestions(
    List<Question> questions, {
    bool includeReviewQuestions = true,
    bool focusWeakAreas = true,
    bool excludeMastered = false,
  }) {
    List<Question> result = List.from(questions);
    
    // Optionally exclude mastered questions
    if (excludeMastered) {
      result = result.where((q) => !_masteredQuestions.contains(q.id)).toList();
    }
    
    // Sort by priority
    result.sort((a, b) {
      // Priority 1: Questions needing review
      if (includeReviewQuestions) {
        final aReview = needsReview(a.id);
        final bReview = needsReview(b.id);
        if (aReview && !bReview) return -1;
        if (!aReview && bReview) return 1;
      }
      
      // Priority 2: Questions from weak areas
      if (focusWeakAreas) {
        final aWeak = isWeakArea(a.subType);
        final bWeak = isWeakArea(b.subType);
        if (aWeak && !bWeak) return -1;
        if (!aWeak && bWeak) return 1;
      }
      
      return 0;
    });
    
    return result;
  }

  // ==================== SUMMARY ====================

  /// Get a summary of smart learning status
  SmartLearningSummary getSummary() {
    return SmartLearningSummary(
      totalQuestionsAttempted: _performanceBySubType.values
          .fold(0, (sum, stats) => sum + stats.totalAttempts),
      weakAreaCount: getWeakSubTypes().length,
      reviewDueCount: reviewCount,
      bookmarkCount: bookmarkCount,
      masteredCount: _masteredQuestions.length,
      totalTestSessions: _testHistory.length,
      averageAccuracy: _calculateOverallAccuracy(),
    );
  }

  double _calculateOverallAccuracy() {
    int total = 0, correct = 0;
    for (final stats in _performanceBySubType.values) {
      total += stats.totalAttempts;
      correct += stats.correctAttempts;
    }
    return total > 0 ? (correct / total) * 100 : 0;
  }

  /// Clear all smart learning data
  Future<void> clearAllData() async {
    _performanceBySubType.clear();
    _bookmarkedQuestions.clear();
    _incorrectQuestions.clear();
    _masteredQuestions.clear();
    _timeBySubType.clear();
    _testHistory.clear();
    await _save();
    notifyListeners();
  }
}

/// Performance statistics for a question subtype
class PerformanceStats {
  final String subType;
  int totalAttempts;
  int correctAttempts;
  DateTime? lastAttempt;

  PerformanceStats({
    required this.subType,
    this.totalAttempts = 0,
    this.correctAttempts = 0,
    this.lastAttempt,
  });

  double get accuracy => totalAttempts > 0 ? (correctAttempts / totalAttempts) * 100 : 0;

  void recordAttempt(bool isCorrect) {
    totalAttempts++;
    if (isCorrect) correctAttempts++;
    lastAttempt = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
    'subType': subType,
    'totalAttempts': totalAttempts,
    'correctAttempts': correctAttempts,
    'lastAttempt': lastAttempt?.toIso8601String(),
  };

  factory PerformanceStats.fromJson(Map<String, dynamic> json) => PerformanceStats(
    subType: json['subType'] ?? '',
    totalAttempts: json['totalAttempts'] ?? 0,
    correctAttempts: json['correctAttempts'] ?? 0,
    lastAttempt: json['lastAttempt'] != null ? DateTime.parse(json['lastAttempt']) : null,
  );
}

/// Summary of smart learning status
class SmartLearningSummary {
  final int totalQuestionsAttempted;
  final int weakAreaCount;
  final int reviewDueCount;
  final int bookmarkCount;
  final int masteredCount;
  final int totalTestSessions;
  final double averageAccuracy;

  SmartLearningSummary({
    required this.totalQuestionsAttempted,
    required this.weakAreaCount,
    required this.reviewDueCount,
    required this.bookmarkCount,
    required this.masteredCount,
    this.totalTestSessions = 0,
    this.averageAccuracy = 0,
  });
}

/// Time statistics for a question subtype
class TimeStats {
  final String subType;
  int totalTime; // in seconds
  int questionCount;
  int? fastestTime;
  int? slowestTime;

  TimeStats({
    required this.subType,
    this.totalTime = 0,
    this.questionCount = 0,
    this.fastestTime,
    this.slowestTime,
  });

  double get averageTime => questionCount > 0 ? totalTime / questionCount : 0;

  void recordTime(int seconds) {
    totalTime += seconds;
    questionCount++;
    if (fastestTime == null || seconds < fastestTime!) fastestTime = seconds;
    if (slowestTime == null || seconds > slowestTime!) slowestTime = seconds;
  }

  Map<String, dynamic> toJson() => {
    'subType': subType,
    'totalTime': totalTime,
    'questionCount': questionCount,
    'fastestTime': fastestTime,
    'slowestTime': slowestTime,
  };

  factory TimeStats.fromJson(Map<String, dynamic> json) => TimeStats(
    subType: json['subType'] ?? '',
    totalTime: json['totalTime'] ?? 0,
    questionCount: json['questionCount'] ?? 0,
    fastestTime: json['fastestTime'],
    slowestTime: json['slowestTime'],
  );
}

/// Record of a completed test session
class TestSessionRecord {
  final DateTime date;
  final int totalQuestions;
  final int correctAnswers;
  final int totalTimeSeconds;
  final String level;

  TestSessionRecord({
    required this.date,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalTimeSeconds,
    required this.level,
  });

  double get accuracy => totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;
  double get averageTimePerQuestion => totalQuestions > 0 ? totalTimeSeconds / totalQuestions : 0;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers,
    'totalTimeSeconds': totalTimeSeconds,
    'level': level,
  };

  factory TestSessionRecord.fromJson(Map<String, dynamic> json) => TestSessionRecord(
    date: DateTime.parse(json['date']),
    totalQuestions: json['totalQuestions'] ?? 0,
    correctAnswers: json['correctAnswers'] ?? 0,
    totalTimeSeconds: json['totalTimeSeconds'] ?? 0,
    level: json['level'] ?? '',
  );
}

/// Point in a trend chart
class TrendPoint {
  final String label;
  final double value;
  final int sessionCount;

  TrendPoint({
    required this.label,
    required this.value,
    required this.sessionCount,
  });
}
