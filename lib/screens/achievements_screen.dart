import 'package:flutter/material.dart';
import '../controllers/gamification_controller.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
  final GamificationController _gamification = GamificationController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _gamification.addListener(_refresh);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _gamification.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final stats = _gamification.getStats();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Stats', icon: Icon(Icons.bar_chart)),
            Tab(text: 'Badges', icon: Icon(Icons.emoji_events)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatsTab(stats, theme),
          _buildAchievementsTab(theme),
        ],
      ),
    );
  }

  Widget _buildStatsTab(GamificationStats stats, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level Card
          _buildLevelCard(stats, theme),
          const SizedBox(height: 16),

          // Stats Grid
          _buildStatsGrid(stats, theme),
          const SizedBox(height: 16),

          // Streak Cards
          Row(
            children: [
              Expanded(
                child: _buildStreakCard(
                  'Answer Streak',
                  stats.currentStreak,
                  stats.bestStreak,
                  '🔥',
                  Colors.orange,
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDailyStreakCard(stats, theme),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Stats
          _buildQuickStats(stats, theme),
        ],
      ),
    );
  }

  Widget _buildLevelCard(GamificationStats stats, ThemeData theme) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              _getLevelColor(stats.currentLevel),
              _getLevelColor(stats.currentLevel).withAlpha(180),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${stats.currentLevel}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getLevelTitle(stats.currentLevel),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(50),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      _getLevelEmoji(stats.currentLevel),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${stats.xpToNextLevel} XP to Level ${stats.currentLevel + 1}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: stats.levelProgress.clamp(0.0, 1.0),
                    minHeight: 12,
                    backgroundColor: Colors.white.withAlpha(80),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(GamificationStats stats, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Points',
            _formatNumber(stats.totalPoints),
            '💰',
            Colors.amber,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Achievements',
            '${stats.achievementsUnlocked}/${stats.totalAchievements}',
            '🏆',
            Colors.purple,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String emoji,
    Color color,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(
    String title,
    int current,
    int best,
    String emoji,
    Color color,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  '$current',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Best: $best',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyStreakCard(GamificationStats stats, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📅', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  '${stats.dailyStreak}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const Text('Daily Streak'),
            const SizedBox(height: 4),
            Text(
              stats.dailyStreak > 0 ? 'Keep it up!' : 'Start today!',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(GamificationStats stats, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildQuickStatRow('Total XP Earned', '${stats.totalXP}', '⚡'),
            _buildQuickStatRow('Current Level', 'Level ${stats.currentLevel}', '📊'),
            _buildQuickStatRow('Best Answer Streak', '${stats.bestStreak}', '🔥'),
            _buildQuickStatRow('Daily Streak', '${stats.dailyStreak} days', '📅'),
            _buildQuickStatRow(
              'Achievements',
              '${stats.achievementsUnlocked} unlocked',
              '🏆',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatRow(String label, String value, String emoji) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab(ThemeData theme) {
    final unlocked = allAchievements
        .where((a) => _gamification.isAchievementUnlocked(a.id))
        .toList();
    final locked = allAchievements
        .where((a) => !_gamification.isAchievementUnlocked(a.id))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (unlocked.isNotEmpty) ...[
          Text(
            'Unlocked (${unlocked.length})',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          ...unlocked.map((a) => _buildAchievementCard(a, true, theme)),
          const SizedBox(height: 24),
        ],
        Text(
          'Locked (${locked.length})',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ...locked.map((a) => _buildAchievementCard(a, false, theme)),
      ],
    );
  }

  Widget _buildAchievementCard(
    Achievement achievement,
    bool isUnlocked,
    ThemeData theme,
  ) {
    final rarityColor = _getRarityColor(achievement.rarity);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isUnlocked
              ? Border.all(color: rarityColor, width: 2)
              : null,
        ),
        child: Opacity(
          opacity: isUnlocked ? 1.0 : 0.5,
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked
                    ? rarityColor.withAlpha(50)
                    : Colors.grey.withAlpha(50),
              ),
              child: Center(
                child: Text(
                  isUnlocked ? achievement.icon : '🔒',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    achievement.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? null : Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: rarityColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    achievement.rarity.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: rarityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: isUnlocked ? null : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '+${achievement.xpReward} XP',
                      style: TextStyle(
                        fontSize: 12,
                        color: isUnlocked ? Colors.blue : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '+${achievement.pointsReward} pts',
                      style: TextStyle(
                        fontSize: 12,
                        color: isUnlocked ? Colors.amber[700] : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: isUnlocked
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(int level) {
    if (level >= 25) return Colors.purple;
    if (level >= 15) return Colors.orange;
    if (level >= 10) return Colors.blue;
    if (level >= 5) return Colors.green;
    return Colors.teal;
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

  String _getLevelEmoji(int level) {
    if (level >= 25) return '👑';
    if (level >= 20) return '🌟';
    if (level >= 15) return '⭐';
    if (level >= 10) return '🎯';
    if (level >= 5) return '📚';
    return '🎓';
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.uncommon:
        return Colors.green;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
