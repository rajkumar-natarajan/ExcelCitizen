import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages gamification features: XP, levels, streaks, achievements, and rewards
class GamificationController extends ChangeNotifier {
  static final GamificationController _instance = GamificationController._internal();
  factory GamificationController() => _instance;
  GamificationController._internal();

  // XP and Level tracking
  int _totalXP = 0;
  int _currentLevel = 1;
  
  // Points tracking
  int _totalPoints = 0;
  int _currentStreak = 0; // Correct answers in a row
  int _bestStreak = 0;
  
  // Daily streak tracking
  int _dailyStreak = 0;
  DateTime? _lastPracticeDate;
  
  // Achievement tracking
  Set<String> _unlockedAchievements = {};
  Map<String, int> _achievementProgress = {};
  
  // Session stats
  int _todayQuestions = 0;
  int _todayCorrect = 0;
  
  bool _isInitialized = false;

  // ==================== GETTERS ====================
  
  int get totalXP => _totalXP;
  int get currentLevel => _currentLevel;
  int get totalPoints => _totalPoints;
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  int get dailyStreak => _dailyStreak;
  int get todayQuestions => _todayQuestions;
  int get todayCorrect => _todayCorrect;
  Set<String> get unlockedAchievements => Set.from(_unlockedAchievements);
  
  /// XP needed for next level (increases each level)
  int get xpForNextLevel => _currentLevel * 100 + (_currentLevel - 1) * 50;
  
  /// XP progress within current level
  int get xpInCurrentLevel {
    int xpForPreviousLevels = 0;
    for (int i = 1; i < _currentLevel; i++) {
      xpForPreviousLevels += i * 100 + (i - 1) * 50;
    }
    return _totalXP - xpForPreviousLevels;
  }
  
  /// Progress percentage to next level (0.0 - 1.0)
  double get levelProgress => xpInCurrentLevel / xpForNextLevel;

  // ==================== INITIALIZATION ====================

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    
    _totalXP = prefs.getInt('gamification_xp') ?? 0;
    _currentLevel = prefs.getInt('gamification_level') ?? 1;
    _totalPoints = prefs.getInt('gamification_points') ?? 0;
    _currentStreak = prefs.getInt('gamification_streak') ?? 0;
    _bestStreak = prefs.getInt('gamification_best_streak') ?? 0;
    _dailyStreak = prefs.getInt('gamification_daily_streak') ?? 0;
    
    final lastPractice = prefs.getString('gamification_last_practice');
    if (lastPractice != null) {
      _lastPracticeDate = DateTime.parse(lastPractice);
    }
    
    final achievements = prefs.getStringList('gamification_achievements');
    if (achievements != null) {
      _unlockedAchievements = achievements.toSet();
    }
    
    final progressJson = prefs.getString('gamification_progress');
    if (progressJson != null) {
      final Map<String, dynamic> data = jsonDecode(progressJson);
      _achievementProgress = data.map((k, v) => MapEntry(k, v as int));
    }
    
    // Check and update daily streak
    _checkDailyStreak();
    
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt('gamification_xp', _totalXP);
    await prefs.setInt('gamification_level', _currentLevel);
    await prefs.setInt('gamification_points', _totalPoints);
    await prefs.setInt('gamification_streak', _currentStreak);
    await prefs.setInt('gamification_best_streak', _bestStreak);
    await prefs.setInt('gamification_daily_streak', _dailyStreak);
    
    if (_lastPracticeDate != null) {
      await prefs.setString('gamification_last_practice', _lastPracticeDate!.toIso8601String());
    }
    
    await prefs.setStringList('gamification_achievements', _unlockedAchievements.toList());
    await prefs.setString('gamification_progress', jsonEncode(_achievementProgress));
  }

  // ==================== DAILY STREAK ====================

  void _checkDailyStreak() {
    if (_lastPracticeDate == null) return;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastPractice = DateTime(
      _lastPracticeDate!.year,
      _lastPracticeDate!.month,
      _lastPracticeDate!.day,
    );
    
    final daysDiff = today.difference(lastPractice).inDays;
    
    if (daysDiff > 1) {
      // Streak broken
      _dailyStreak = 0;
    }
    // If daysDiff == 1, streak continues when they practice today
    // If daysDiff == 0, already practiced today
  }

  void _updateDailyStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_lastPracticeDate == null) {
      _dailyStreak = 1;
      _lastPracticeDate = now;
      return;
    }
    
    final lastPractice = DateTime(
      _lastPracticeDate!.year,
      _lastPracticeDate!.month,
      _lastPracticeDate!.day,
    );
    
    final daysDiff = today.difference(lastPractice).inDays;
    
    if (daysDiff == 0) {
      // Already practiced today
      return;
    } else if (daysDiff == 1) {
      // Consecutive day!
      _dailyStreak++;
      _checkAchievement(AchievementType.dailyStreak, _dailyStreak);
    } else {
      // Streak broken, start new
      _dailyStreak = 1;
    }
    
    _lastPracticeDate = now;
  }

  // ==================== POINTS & XP SYSTEM ====================

  /// Award points and XP for answering a question
  GamificationReward recordAnswer({
    required bool isCorrect,
    required String questionType,
    int? timeBonus, // bonus for fast answers
  }) {
    _todayQuestions++;
    GamificationReward reward = GamificationReward();
    
    if (isCorrect) {
      _todayCorrect++;
      
      // Base points
      int points = 10;
      int xp = 5;
      
      // Streak bonus
      _currentStreak++;
      if (_currentStreak > _bestStreak) {
        _bestStreak = _currentStreak;
      }
      
      // Streak multiplier
      if (_currentStreak >= 10) {
        points += 20; // 10+ streak bonus
        xp += 10;
        reward.streakBonus = 20;
      } else if (_currentStreak >= 5) {
        points += 10; // 5+ streak bonus
        xp += 5;
        reward.streakBonus = 10;
      } else if (_currentStreak >= 3) {
        points += 5; // 3+ streak bonus
        xp += 2;
        reward.streakBonus = 5;
      }
      
      // Time bonus (if answered quickly)
      if (timeBonus != null && timeBonus > 0) {
        points += timeBonus;
        reward.timeBonus = timeBonus;
      }
      
      _totalPoints += points;
      _totalXP += xp;
      
      reward.pointsEarned = points;
      reward.xpEarned = xp;
      reward.currentStreak = _currentStreak;
      
      // Check for level up
      _checkLevelUp(reward);
      
      // Check achievements
      _checkAchievement(AchievementType.totalCorrect, _todayCorrect);
      _checkAchievement(AchievementType.answerStreak, _currentStreak);
      _checkAchievement(AchievementType.totalXP, _totalXP);
      
    } else {
      // Wrong answer breaks streak
      _currentStreak = 0;
      reward.currentStreak = 0;
    }
    
    // Update daily streak
    _updateDailyStreak();
    
    _save();
    notifyListeners();
    
    return reward;
  }

  /// Record completion of a test session
  GamificationReward recordTestCompletion({
    required int totalQuestions,
    required int correctAnswers,
    required int totalTimeSeconds,
  }) {
    GamificationReward reward = GamificationReward();
    
    // Completion bonus
    int points = 50;
    int xp = 25;
    
    // Perfect score bonus
    if (correctAnswers == totalQuestions) {
      points += 100;
      xp += 50;
      reward.perfectBonus = true;
      _checkAchievement(AchievementType.perfectTest, 1);
    }
    
    // Accuracy bonus
    double accuracy = totalQuestions > 0 ? correctAnswers / totalQuestions : 0;
    if (accuracy >= 0.9) {
      points += 30;
      xp += 15;
    } else if (accuracy >= 0.8) {
      points += 20;
      xp += 10;
    }
    
    // Speed bonus
    double avgTime = totalQuestions > 0 ? totalTimeSeconds / totalQuestions : 0;
    if (avgTime < 20 && accuracy >= 0.7) {
      points += 25;
      xp += 12;
      reward.speedBonus = true;
    }
    
    _totalPoints += points;
    _totalXP += xp;
    
    reward.pointsEarned = points;
    reward.xpEarned = xp;
    
    // Increment achievement progress
    _incrementProgress(AchievementType.testsCompleted);
    _checkAchievement(AchievementType.testsCompleted, _getProgress(AchievementType.testsCompleted));
    
    _checkLevelUp(reward);
    
    _save();
    notifyListeners();
    
    return reward;
  }

  void _checkLevelUp(GamificationReward reward) {
    int xpForPreviousLevels = 0;
    for (int i = 1; i <= _currentLevel; i++) {
      xpForPreviousLevels += i * 100 + (i - 1) * 50;
    }
    
    if (_totalXP >= xpForPreviousLevels) {
      _currentLevel++;
      reward.leveledUp = true;
      reward.newLevel = _currentLevel;
      _checkAchievement(AchievementType.level, _currentLevel);
    }
  }

  // ==================== ACHIEVEMENTS ====================

  void _incrementProgress(AchievementType type) {
    final key = type.name;
    _achievementProgress[key] = (_achievementProgress[key] ?? 0) + 1;
  }

  int _getProgress(AchievementType type) {
    return _achievementProgress[type.name] ?? 0;
  }

  void _checkAchievement(AchievementType type, int value) {
    for (final achievement in allAchievements) {
      if (achievement.type == type && 
          value >= achievement.requirement &&
          !_unlockedAchievements.contains(achievement.id)) {
        _unlockAchievement(achievement);
      }
    }
  }

  void _unlockAchievement(Achievement achievement) {
    _unlockedAchievements.add(achievement.id);
    _totalXP += achievement.xpReward;
    _totalPoints += achievement.pointsReward;
    // TODO: Trigger notification/animation for new achievement
    notifyListeners();
  }

  bool isAchievementUnlocked(String achievementId) {
    return _unlockedAchievements.contains(achievementId);
  }

  int getAchievementProgress(AchievementType type) {
    return _getProgress(type);
  }

  // ==================== STATS ====================

  GamificationStats getStats() {
    return GamificationStats(
      totalXP: _totalXP,
      currentLevel: _currentLevel,
      totalPoints: _totalPoints,
      currentStreak: _currentStreak,
      bestStreak: _bestStreak,
      dailyStreak: _dailyStreak,
      achievementsUnlocked: _unlockedAchievements.length,
      totalAchievements: allAchievements.length,
      levelProgress: levelProgress,
      xpToNextLevel: xpForNextLevel - xpInCurrentLevel,
    );
  }

  /// Reset today's stats (for testing)
  void resetDailyStats() {
    _todayQuestions = 0;
    _todayCorrect = 0;
    notifyListeners();
  }

  /// Clear all gamification data
  Future<void> clearAllData() async {
    _totalXP = 0;
    _currentLevel = 1;
    _totalPoints = 0;
    _currentStreak = 0;
    _bestStreak = 0;
    _dailyStreak = 0;
    _lastPracticeDate = null;
    _unlockedAchievements.clear();
    _achievementProgress.clear();
    _todayQuestions = 0;
    _todayCorrect = 0;
    await _save();
    notifyListeners();
  }
}

// ==================== DATA CLASSES ====================

/// Reward data returned after an action
class GamificationReward {
  int pointsEarned = 0;
  int xpEarned = 0;
  int streakBonus = 0;
  int timeBonus = 0;
  int currentStreak = 0;
  bool leveledUp = false;
  int? newLevel;
  bool perfectBonus = false;
  bool speedBonus = false;
  List<Achievement> newAchievements = [];
  
  bool get hasReward => pointsEarned > 0 || xpEarned > 0 || leveledUp || newAchievements.isNotEmpty;
}

/// Current gamification stats
class GamificationStats {
  final int totalXP;
  final int currentLevel;
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;
  final int dailyStreak;
  final int achievementsUnlocked;
  final int totalAchievements;
  final double levelProgress;
  final int xpToNextLevel;

  GamificationStats({
    required this.totalXP,
    required this.currentLevel,
    required this.totalPoints,
    required this.currentStreak,
    required this.bestStreak,
    required this.dailyStreak,
    required this.achievementsUnlocked,
    required this.totalAchievements,
    required this.levelProgress,
    required this.xpToNextLevel,
  });
}

/// Achievement types for tracking
enum AchievementType {
  totalCorrect,
  answerStreak,
  dailyStreak,
  testsCompleted,
  perfectTest,
  totalXP,
  level,
}

/// Achievement definition
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final int requirement;
  final int xpReward;
  final int pointsReward;
  final AchievementRarity rarity;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.requirement,
    this.xpReward = 50,
    this.pointsReward = 100,
    this.rarity = AchievementRarity.common,
  });
}

enum AchievementRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

/// All available achievements
const List<Achievement> allAchievements = [
  // First steps
  Achievement(
    id: 'first_correct',
    name: 'First Steps',
    description: 'Answer your first question correctly',
    icon: '🎯',
    type: AchievementType.totalCorrect,
    requirement: 1,
    xpReward: 10,
    pointsReward: 25,
  ),
  Achievement(
    id: 'correct_10',
    name: 'Getting Started',
    description: 'Answer 10 questions correctly',
    icon: '⭐',
    type: AchievementType.totalCorrect,
    requirement: 10,
    xpReward: 25,
    pointsReward: 50,
  ),
  Achievement(
    id: 'correct_50',
    name: 'Knowledge Seeker',
    description: 'Answer 50 questions correctly',
    icon: '📚',
    type: AchievementType.totalCorrect,
    requirement: 50,
    xpReward: 50,
    pointsReward: 100,
    rarity: AchievementRarity.uncommon,
  ),
  Achievement(
    id: 'correct_100',
    name: 'Scholar',
    description: 'Answer 100 questions correctly',
    icon: '🎓',
    type: AchievementType.totalCorrect,
    requirement: 100,
    xpReward: 100,
    pointsReward: 200,
    rarity: AchievementRarity.rare,
  ),
  Achievement(
    id: 'correct_500',
    name: 'Master Mind',
    description: 'Answer 500 questions correctly',
    icon: '🧠',
    type: AchievementType.totalCorrect,
    requirement: 500,
    xpReward: 250,
    pointsReward: 500,
    rarity: AchievementRarity.epic,
  ),
  
  // Streak achievements
  Achievement(
    id: 'streak_3',
    name: 'On Fire',
    description: 'Get 3 correct answers in a row',
    icon: '🔥',
    type: AchievementType.answerStreak,
    requirement: 3,
    xpReward: 15,
    pointsReward: 30,
  ),
  Achievement(
    id: 'streak_5',
    name: 'Hot Streak',
    description: 'Get 5 correct answers in a row',
    icon: '💥',
    type: AchievementType.answerStreak,
    requirement: 5,
    xpReward: 25,
    pointsReward: 50,
    rarity: AchievementRarity.uncommon,
  ),
  Achievement(
    id: 'streak_10',
    name: 'Unstoppable',
    description: 'Get 10 correct answers in a row',
    icon: '⚡',
    type: AchievementType.answerStreak,
    requirement: 10,
    xpReward: 50,
    pointsReward: 100,
    rarity: AchievementRarity.rare,
  ),
  Achievement(
    id: 'streak_20',
    name: 'Legend',
    description: 'Get 20 correct answers in a row',
    icon: '👑',
    type: AchievementType.answerStreak,
    requirement: 20,
    xpReward: 100,
    pointsReward: 200,
    rarity: AchievementRarity.epic,
  ),
  
  // Daily streak
  Achievement(
    id: 'daily_3',
    name: 'Consistent',
    description: 'Practice for 3 days in a row',
    icon: '📅',
    type: AchievementType.dailyStreak,
    requirement: 3,
    xpReward: 30,
    pointsReward: 60,
  ),
  Achievement(
    id: 'daily_7',
    name: 'Dedicated',
    description: 'Practice for 7 days in a row',
    icon: '🗓️',
    type: AchievementType.dailyStreak,
    requirement: 7,
    xpReward: 75,
    pointsReward: 150,
    rarity: AchievementRarity.uncommon,
  ),
  Achievement(
    id: 'daily_30',
    name: 'Committed',
    description: 'Practice for 30 days in a row',
    icon: '💪',
    type: AchievementType.dailyStreak,
    requirement: 30,
    xpReward: 200,
    pointsReward: 400,
    rarity: AchievementRarity.rare,
  ),
  
  // Tests completed
  Achievement(
    id: 'test_1',
    name: 'Test Taker',
    description: 'Complete your first test',
    icon: '📝',
    type: AchievementType.testsCompleted,
    requirement: 1,
    xpReward: 20,
    pointsReward: 40,
  ),
  Achievement(
    id: 'test_10',
    name: 'Test Pro',
    description: 'Complete 10 tests',
    icon: '🏆',
    type: AchievementType.testsCompleted,
    requirement: 10,
    xpReward: 75,
    pointsReward: 150,
    rarity: AchievementRarity.uncommon,
  ),
  Achievement(
    id: 'test_50',
    name: 'Test Master',
    description: 'Complete 50 tests',
    icon: '🥇',
    type: AchievementType.testsCompleted,
    requirement: 50,
    xpReward: 200,
    pointsReward: 400,
    rarity: AchievementRarity.rare,
  ),
  
  // Perfect tests
  Achievement(
    id: 'perfect_1',
    name: 'Perfect Score',
    description: 'Get 100% on a test',
    icon: '💯',
    type: AchievementType.perfectTest,
    requirement: 1,
    xpReward: 50,
    pointsReward: 100,
    rarity: AchievementRarity.uncommon,
  ),
  
  // Level achievements
  Achievement(
    id: 'level_5',
    name: 'Rising Star',
    description: 'Reach level 5',
    icon: '🌟',
    type: AchievementType.level,
    requirement: 5,
    xpReward: 100,
    pointsReward: 200,
    rarity: AchievementRarity.uncommon,
  ),
  Achievement(
    id: 'level_10',
    name: 'Expert',
    description: 'Reach level 10',
    icon: '🌠',
    type: AchievementType.level,
    requirement: 10,
    xpReward: 200,
    pointsReward: 400,
    rarity: AchievementRarity.rare,
  ),
  Achievement(
    id: 'level_25',
    name: 'Champion',
    description: 'Reach level 25',
    icon: '🏅',
    type: AchievementType.level,
    requirement: 25,
    xpReward: 500,
    pointsReward: 1000,
    rarity: AchievementRarity.epic,
  ),
  
  // XP milestones
  Achievement(
    id: 'xp_1000',
    name: 'XP Hunter',
    description: 'Earn 1,000 total XP',
    icon: '💎',
    type: AchievementType.totalXP,
    requirement: 1000,
    xpReward: 100,
    pointsReward: 200,
    rarity: AchievementRarity.rare,
  ),
  Achievement(
    id: 'xp_5000',
    name: 'XP Master',
    description: 'Earn 5,000 total XP',
    icon: '💠',
    type: AchievementType.totalXP,
    requirement: 5000,
    xpReward: 250,
    pointsReward: 500,
    rarity: AchievementRarity.epic,
  ),
  Achievement(
    id: 'xp_10000',
    name: 'XP Legend',
    description: 'Earn 10,000 total XP',
    icon: '🔮',
    type: AchievementType.totalXP,
    requirement: 10000,
    xpReward: 500,
    pointsReward: 1000,
    rarity: AchievementRarity.legendary,
  ),
];
