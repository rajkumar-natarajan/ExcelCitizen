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
        final allStats = _smartLearning.allStats;
        int totalAttempts = 0;
        for (var stat in allStats.values) {
          totalAttempts += stat.totalAttempts;
        }
        
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
              _buildOverviewTab(context, totalAttempts),
              _buildTrendsTab(context),
              _buildTimeStatsTab(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(BuildContext context, int totalAttempts) {
    final allStats = _smartLearning.allStats;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSummaryCard(context, totalAttempts),
        const SizedBox(height: 16),
        _buildSmartLearningCard(context),
        const SizedBox(height: 24),
        Text(
          'Performance by Category',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildCategoryProgress(
          context, 
          'Rights & Responsibilities', 
          _calculateCategoryAccuracy(allStats, QuestionType.rightsResponsibilities),
          Colors.blue,
        ),
        _buildCategoryProgress(
          context, 
          'History', 
          _calculateCategoryAccuracy(allStats, QuestionType.history),
          Colors.red,
        ),
        _buildCategoryProgress(
          context, 
          'Government', 
          _calculateCategoryAccuracy(allStats, QuestionType.government),
          Colors.purple,
        ),
        _buildCategoryProgress(
          context, 
          'Geography', 
          _calculateCategoryAccuracy(allStats, QuestionType.geography),
          Colors.green,
        ),
        _buildCategoryProgress(
          context, 
          'Symbols', 
          _calculateCategoryAccuracy(allStats, QuestionType.symbols),
          Colors.orange,
        ),
        _buildCategoryProgress(
          context, 
          'Economy', 
          _calculateCategoryAccuracy(allStats, QuestionType.economy),
          Colors.teal,
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
    final recentSessions = _smartLearning.getRecentSessions(10);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAccuracyTrendChart(context, trend),
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
              backgroundColor: _getColorForAccuracy(session.accuracy * 100).withValues(alpha: 0.2),
              child: Text(
                '${(session.accuracy * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getColorForAccuracy(session.accuracy * 100),
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
                  session.testType,
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
    final rights = _smartLearning.getAverageTimeForType(QuestionType.rightsResponsibilities);
    final history = _smartLearning.getAverageTimeForType(QuestionType.history);
    final government = _smartLearning.getAverageTimeForType(QuestionType.government);
    
    final hasData = rights > 0 || history > 0 || government > 0;
    
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
                _buildTimeStatCircle(context, 'Rights', rights, Colors.blue),
                _buildTimeStatCircle(context, 'History', history, Colors.red),
                _buildTimeStatCircle(context, 'Govt', government, Colors.purple),
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
            color: color.withValues(alpha: 0.1),
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTimeCategoryCard(
                context,
                'Rights',
                _smartLearning.getAverageTimeForType(QuestionType.rightsResponsibilities),
                Colors.blue,
                Icons.balance,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTimeCategoryCard(
                context,
                'History',
                _smartLearning.getAverageTimeForType(QuestionType.history),
                Colors.red,
                Icons.history_edu,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTimeCategoryCard(
                context,
                'Govt',
                _smartLearning.getAverageTimeForType(QuestionType.government),
                Colors.purple,
                Icons.account_balance,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTimeCategoryCard(
                context,
                'Geography',
                _smartLearning.getAverageTimeForType(QuestionType.geography),
                Colors.green,
                Icons.map,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTimeCategoryCard(
                context,
                'Symbols',
                _smartLearning.getAverageTimeForType(QuestionType.symbols),
                Colors.orange,
                Icons.flag,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTimeCategoryCard(
                context,
                'Economy',
                _smartLearning.getAverageTimeForType(QuestionType.economy),
                Colors.teal,
                Icons.trending_up,
              ),
            ),
          ],
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
            trailing: Text(
              'Avg: ${stats.averageTime.toStringAsFixed(1)}s',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
      case QuestionType.rightsResponsibilities:
        return [
          RightsSubType.citizenshipRights.value,
          RightsSubType.responsibilities.value,
          RightsSubType.charterOfRights.value,
          RightsSubType.equality.value,
        ];
      case QuestionType.history:
        return [
          HistorySubType.aboriginal.value,
          HistorySubType.exploration.value,
          HistorySubType.confederation.value,
          HistorySubType.modernCanada.value,
          HistorySubType.worldWars.value,
        ];
      case QuestionType.government:
        return [
          GovernmentSubType.federalGovernment.value,
          GovernmentSubType.provincialGovernment.value,
          GovernmentSubType.elections.value,
          GovernmentSubType.monarchy.value,
        ];
      case QuestionType.geography:
        return [
          GeographySubType.provinces.value,
          GeographySubType.capitals.value,
          GeographySubType.regions.value,
          GeographySubType.naturalResources.value,
        ];
      case QuestionType.symbols:
        return [
          SymbolsSubType.nationalSymbols.value,
          SymbolsSubType.holidays.value,
          SymbolsSubType.anthem.value,
          SymbolsSubType.flags.value,
        ];
      case QuestionType.economy:
        return ['economy_general', 'trade', 'industries'];
    }
  }

  Widget _buildSummaryCard(BuildContext context, int totalAttempts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(context, 'Attempted', '$totalAttempts'),
            _buildStat(context, 'Mastered', '${_smartLearning.masteredCount}'),
            _buildStat(context, 'Bookmarks', '${_smartLearning.bookmarkCount}'),
          ],
        ),
      ),
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

  Widget _buildSmartLearningCard(BuildContext context) {
    final weakAreas = _smartLearning.getWeakAreas();
    final reviewDue = _smartLearning.getQuestionsForReview();
    
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                    '${weakAreas.length}',
                    'Weak Areas',
                  ),
                ),
                Expanded(
                  child: _buildSmartStatTile(
                    context,
                    Icons.replay_rounded,
                    Colors.blue,
                    '${reviewDue.length}',
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
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
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
    );
  }

  Widget _buildCategoryProgress(
    BuildContext context,
    String label,
    double progress,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('${(progress * 100).toInt()}%'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: color.withValues(alpha: 0.1),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildWeakAreasSection(BuildContext context) {
    final weakAreas = _smartLearning.getWeakAreas();
    
    if (weakAreas.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No weak areas identified yet. Keep practicing!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: weakAreas.take(5).map((area) {
        final stats = _smartLearning.getStats(area);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.warning_amber, color: Colors.orange),
            title: Text(area),
            trailing: Text(
              '${((stats?.accuracy ?? 0) * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
