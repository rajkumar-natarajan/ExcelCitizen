import 'package:flutter/material.dart';
import '../controllers/gamification_controller.dart';
import '../controllers/settings_controller.dart';
import '../data/question_data_manager.dart';
import '../models/question.dart';
import '../widgets/canadian_theme.dart';
import 'achievements_screen.dart';
import 'test_session_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GamificationController _gamification = GamificationController();
  final SettingsController _settings = SettingsController();

  @override
  void initState() {
    super.initState();
    _gamification.addListener(_refresh);
    _settings.addListener(_refresh);
  }

  @override
  void dispose() {
    _gamification.removeListener(_refresh);
    _settings.removeListener(_refresh);
    super.dispose();
  }

  bool get _isFrench => _settings.language == Language.french;

  void _refresh() => setState(() {});

  void _startCategoryPractice(QuestionType type) {
    final dataManager = QuestionDataManager();
    final questions = dataManager.getQuestionsByType(type);
    
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isFrench ? 'Aucune question disponible' : 'No questions available')),
      );
      return;
    }

    // Shuffle and take up to 10 questions for quick practice
    final shuffled = List<Question>.from(questions)..shuffle();
    final selectedQuestions = shuffled.take(10).toList();

    final config = TestConfiguration(
      testType: TestType.standardPractice,
      questionCount: selectedQuestions.length,
      timeInMinutes: 10,
      difficulty: _settings.defaultDifficulty,
      selectedTypes: {type},
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestSessionScreen(
          configuration: config,
          questions: selectedQuestions,
          language: _settings.language,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🍁', style: TextStyle(fontSize: 24)), // Maple Leaf
            const SizedBox(width: 8),
            Text(
              'ExcelCitizen',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            tooltip: 'Achievements',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AchievementsScreen()),
              );
            },
          ),
        ],
      ),
      body: CanadianBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildGamificationCard(context),
            const SizedBox(height: 16),
            _buildWelcomeCard(context),
            const SizedBox(height: 24),
            Text(
              _isFrench ? 'Actions rapides' : 'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildQuickActionGrid(context),
            const SizedBox(height: 24),
            Text(
              _isFrench ? 'Défis quotidiens' : 'Daily Challenges',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDailyChallenges(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGamificationCard(BuildContext context) {
    final stats = _gamification.getStats();
    
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AchievementsScreen()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGamificationStat(
                    '⚡',
                    'Level ${stats.currentLevel}',
                    _getLevelTitle(stats.currentLevel),
                    Theme.of(context).colorScheme.primary,
                  ),
                  _buildGamificationStat(
                    '🔥',
                    '${stats.dailyStreak}',
                    'Day Streak',
                    Colors.orange,
                  ),
                  _buildGamificationStat(
                    '💰',
                    _formatNumber(stats.totalPoints),
                    'Points',
                    Colors.amber.shade700,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // XP Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${stats.totalXP} XP',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${stats.xpToNextLevel} to Level ${stats.currentLevel + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: stats.levelProgress.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGamificationStat(String emoji, String value, String label, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withAlpha(180),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyChallenges(BuildContext context) {
    final stats = _gamification.getStats();
    
    return Column(
      children: [
        _buildChallengeItem(
          context,
          '🎯',
          'Complete 5 Questions',
          _gamification.todayQuestions,
          5,
          '+25 XP',
        ),
        const SizedBox(height: 8),
        _buildChallengeItem(
          context,
          '✅',
          'Get 3 Correct in a Row',
          stats.currentStreak.clamp(0, 3),
          3,
          '+15 XP',
        ),
        const SizedBox(height: 8),
        _buildChallengeItem(
          context,
          '🏆',
          'Complete a Full Test',
          _gamification.todayQuestions >= 10 ? 1 : 0,
          1,
          '+50 XP',
        ),
      ],
    );
  }

  Widget _buildChallengeItem(
    BuildContext context,
    String emoji,
    String title,
    int current,
    int target,
    String reward,
  ) {
    final isComplete = current >= target;
    final progress = (current / target).clamp(0.0, 1.0);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isComplete 
                    ? Colors.green.withAlpha(50)
                    : Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isComplete
                    ? const Icon(Icons.check, color: Colors.green)
                    : Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: isComplete ? TextDecoration.lineThrough : null,
                          color: isComplete ? Colors.grey : null,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isComplete ? Colors.green : Colors.blue.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isComplete ? '✓ Done' : reward,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isComplete ? Colors.white : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      color: isComplete ? Colors.green : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLevelTitle(int level) {
    if (level >= 25) return 'Champion';
    if (level >= 20) return 'Expert';
    if (level >= 15) return 'Advanced';
    if (level >= 10) return 'Intermediate';
    if (level >= 5) return 'Rising Star';
    if (level >= 2) return 'Learner';
    return 'Beginner';
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFC8102E), // Canadian Red
            const Color(0xFFC8102E).withAlpha(200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8102E).withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.waving_hand,
                  color: Colors.white.withAlpha(230),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  _isFrench ? 'Bienvenue!' : 'Welcome back!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _isFrench 
                  ? 'Prêt à réussir votre examen de citoyenneté? Commencez votre pratique quotidienne.'
                  : 'Ready to ace your Citizenship? Start your daily practice now.',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => widget.onNavigate(1), // Navigate to Practice tab
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(_isFrench ? 'Commencer la pratique' : 'Start Daily Practice'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFC8102E),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildActionCard(
          context,
          _isFrench ? 'Histoire' : 'History',
          Icons.history_edu,
          Colors.blue,
          () => _startCategoryPractice(QuestionType.history),
        ),
        _buildActionCard(
          context,
          _isFrench ? 'Gouvernement' : 'Government',
          Icons.account_balance,
          Colors.green,
          () => _startCategoryPractice(QuestionType.government),
        ),
        _buildActionCard(
          context,
          _isFrench ? 'Droits' : 'Rights',
          Icons.gavel,
          Colors.orange,
          () => _startCategoryPractice(QuestionType.rightsResponsibilities),
        ),
        _buildActionCard(
          context,
          _isFrench ? 'Géographie' : 'Geography',
          Icons.map,
          Colors.purple,
          () => _startCategoryPractice(QuestionType.geography),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shadowColor: color.withAlpha(80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
