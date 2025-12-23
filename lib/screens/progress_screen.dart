import 'package:flutter/material.dart';
import '../controllers/smart_learning_controller.dart';
import '../models/question.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  final SmartLearningController _smartLearning = SmartLearningController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _smartLearning,
      builder: (context, _) {
        final summary = _smartLearning.getSummary();
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Progress'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Trends'),
                Tab(text: 'Time Stats'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(context, summary),
              _buildTrendsTab(context),
              _buildTimeStatsTab(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(BuildContext context, SmartLearningSummary summary) {
    final allStats = _smartLearning.allStats;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(context, summary),
        const SizedBox(height: 16),
        _buildSmartLearningCard(context, summary),
        const SizedBox(height: 24),
        Text(
          'Performance by Category',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildCategoryProgress(
          context, 
          'Verbal', 
          _calculateCategoryAccuracy(allStats, QuestionType.verbal),
          Colors.blue,
        ),
        _buildCategoryProgress(
          context, 
          'Quantitative', 
          _calculateCategoryAccuracy(allStats, QuestionType.quantitative),
          Colors.green,
        ),
        _buildCategoryProgress(
          context, 
          'Non-Verbal', 
          _calculateCategoryAccuracy(allStats, QuestionType.nonVerbal),
          Colors.orange,
        ),
        const SizedBox(height: 24),
        Text(
          'Weak Areas',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildWeakAreasSection(context),
      ],
    );
  }

  Widget _buildTrendsTab(BuildContext context) {
    final trend = _smartLearning.getAccuracyTrend();
    final dailyPractice = _smartLearning.getDailyPracticeCount(7);
    final recentSessions = _smartLearning.getRecentSessions(10);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAccuracyTrendChart(context, trend),
        const SizedBox(height: 24),
        _buildDailyPracticeChart(context, dailyPractice),
        const SizedBox(height: 24),
        Text(
          'Recent Test Sessions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildRecentSessionsList(context, recentSessions),
      ],
    );
  }

  Widget _buildTimeStatsTab(BuildContext context) {
    final timeStats = _smartLearning.allTimeStats;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTimeOverviewCard(context),
        const SizedBox(height: 24),
        Text(
          'Average Time by Category',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildTimeByCategory(context),
        const SizedBox(height: 24),
        Text(
          'Detailed Time Stats',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildDetailedTimeStats(context, timeStats),
      ],
    );
  }

  Widget _buildAccuracyTrendChart(BuildContext context, List<TrendPoint> trend) {
    if (trend.isEmpty) {
      return _buildEmptyChartCard(
        context,
        'Accuracy Trend',
        'Complete some tests to see your accuracy trend over time.',
        Icons.trending_up,
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Weekly Accuracy Trend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: _buildSimpleBarChart(context, trend, Colors.green),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: trend.map((p) => Text(
                p.label.split('-').last,
                style: Theme.of(context).textTheme.bodySmall,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyPracticeChart(BuildContext context, List<TrendPoint> dailyPractice) {
    if (dailyPractice.isEmpty || dailyPractice.every((p) => p.value == 0)) {
      return _buildEmptyChartCard(
        context,
        'Daily Practice',
        'Start practicing to track your daily activity.',
        Icons.calendar_today,
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Last 7 Days Activity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: dailyPractice.map((p) {
                  final maxVal = dailyPractice.map((d) => d.value).reduce((a, b) => a > b ? a : b);
                  final height = maxVal > 0 ? (p.value / maxVal) * 80 : 0.0;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${p.value.toInt()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 30,
                        height: height.clamp(4.0, 80.0),
                        decoration: BoxDecoration(
                          color: p.value > 0 
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleBarChart(BuildContext context, List<TrendPoint> data, Color color) {
    final maxVal = data.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((point) {
        final height = maxVal > 0 ? (point.value / 100) * 130 : 0.0;
        return Tooltip(
          message: '${point.value.toStringAsFixed(1)}%',
          child: Container(
            width: 40,
            height: height.clamp(8.0, 130.0),
            decoration: BoxDecoration(
              color: _getColorForAccuracy(point.value),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '${point.value.toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForAccuracy(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildEmptyChartCard(BuildContext context, String title, String message, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessionsList(BuildContext context, List<TestSessionRecord> sessions) {
    if (sessions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.history, color: Colors.grey),
              const SizedBox(width: 12),
              Text(
                'No test sessions yet. Start practicing!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: sessions.map((session) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getColorForAccuracy(session.accuracy).withOpacity(0.2),
              child: Text(
                '${session.accuracy.toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getColorForAccuracy(session.accuracy),
                ),
              ),
            ),
            title: Text('${session.correctAnswers}/${session.totalQuestions} correct'),
            subtitle: Text(_formatDate(session.date)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDuration(session.totalTimeSeconds),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  session.level.replaceAll('_', ' '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeOverviewCard(BuildContext context) {
    final verbal = _smartLearning.getAverageTimeForType(QuestionType.verbal);
    final quant = _smartLearning.getAverageTimeForType(QuestionType.quantitative);
    final nonVerbal = _smartLearning.getAverageTimeForType(QuestionType.nonVerbal);
    
    final hasData = verbal > 0 || quant > 0 || nonVerbal > 0;
    
    if (!hasData) {
      return _buildEmptyChartCard(
        context,
        'Time Analytics',
        'Complete tests with timing to see time statistics.',
        Icons.timer,
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Average Time Per Question',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeStatCircle(context, 'Verbal', verbal, Colors.blue),
                _buildTimeStatCircle(context, 'Quant', quant, Colors.green),
                _buildTimeStatCircle(context, 'Non-Verbal', nonVerbal, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeStatCircle(BuildContext context, String label, double seconds, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Text(
              seconds > 0 ? '${seconds.toInt()}s' : '-',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildTimeByCategory(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeCategoryCard(
            context,
            'Verbal',
            _smartLearning.getAverageTimeForType(QuestionType.verbal),
            Colors.blue,
            Icons.text_fields,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTimeCategoryCard(
            context,
            'Quantitative',
            _smartLearning.getAverageTimeForType(QuestionType.quantitative),
            Colors.green,
            Icons.calculate,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTimeCategoryCard(
            context,
            'Non-Verbal',
            _smartLearning.getAverageTimeForType(QuestionType.nonVerbal),
            Colors.orange,
            Icons.shape_line,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCategoryCard(
    BuildContext context,
    String label,
    double avgSeconds,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              avgSeconds > 0 ? '${avgSeconds.toStringAsFixed(1)}s' : '-',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedTimeStats(BuildContext context, Map<String, TimeStats> timeStats) {
    if (timeStats.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.grey),
              const SizedBox(width: 12),
              Text(
                'No timing data yet.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: timeStats.entries.map((entry) {
        final stats = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(entry.key),
            subtitle: Text('${stats.questionCount} questions answered'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Avg: ${stats.averageTime.toStringAsFixed(1)}s',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (stats.fastestTime != null && stats.slowestTime != null)
                  Text(
                    '${stats.fastestTime}s - ${stats.slowestTime}s',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }

  double _calculateCategoryAccuracy(Map<String, PerformanceStats> allStats, QuestionType type) {
    // Get subtypes for this category
    final subtypes = _getSubtypesForType(type);
    int total = 0;
    int correct = 0;
    
    for (final subtype in subtypes) {
      if (allStats.containsKey(subtype)) {
        total += allStats[subtype]!.totalAttempts;
        correct += allStats[subtype]!.correctAttempts;
      }
    }
    
    return total > 0 ? correct / total : 0.0;
  }

  List<String> _getSubtypesForType(QuestionType type) {
    switch (type) {
      case QuestionType.verbal:
        return ['Synonyms', 'Antonyms', 'Analogies', 'Sentence Completion', 'Classification'];
      case QuestionType.quantitative:
        return ['Number Analogies', 'Number Series', 'Quantitative Relations'];
      case QuestionType.nonVerbal:
        return ['Figure Analogies', 'Figure Classification', 'Pattern Completion'];
    }
  }

  Widget _buildSummaryCard(BuildContext context, SmartLearningSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(context, 'Attempted', '${summary.totalQuestionsAttempted}'),
            _buildStat(context, 'Mastered', '${summary.masteredCount}'),
            _buildStat(context, 'Bookmarks', '${summary.bookmarkCount}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartLearningCard(BuildContext context, SmartLearningSummary summary) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Smart Learning Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSmartStatTile(
                    context,
                    Icons.warning_amber_rounded,
                    Colors.orange,
                    '${summary.weakAreaCount}',
                    'Weak Areas',
                  ),
                ),
                Expanded(
                  child: _buildSmartStatTile(
                    context,
                    Icons.replay_rounded,
                    Colors.blue,
                    '${summary.reviewDueCount}',
                    'Due for Review',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartStatTile(
    BuildContext context,
    IconData icon,
    Color color,
    String value,
    String label,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeakAreasSection(BuildContext context) {
    final weakAreas = _smartLearning.getWeakSubTypes();
    
    if (weakAreas.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _smartLearning.getSummary().totalQuestionsAttempted > 0
                      ? 'Great job! No weak areas identified. Keep practicing!'
                      : 'Complete some practice tests to identify areas for improvement.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: weakAreas.map((subtype) {
        final stats = _smartLearning.getStats(subtype);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.warning_amber, color: Colors.orange),
            ),
            title: Text(subtype),
            subtitle: Text(
              'Accuracy: ${stats?.accuracy.toStringAsFixed(1)}% (${stats?.correctAttempts}/${stats?.totalAttempts})',
            ),
            trailing: FilledButton.tonal(
              onPressed: () {
                // TODO: Navigate to practice with this subtype
              },
              child: const Text('Practice'),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildCategoryProgress(
    BuildContext context,
    String label,
    double progress,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              Text('${(progress * 100).toInt()}%'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: color.withOpacity(0.1),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
