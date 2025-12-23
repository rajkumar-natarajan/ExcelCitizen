import 'package:flutter/material.dart';
import '../models/question.dart';
import '../data/question_data_manager.dart';
import '../controllers/settings_controller.dart';
import '../controllers/smart_learning_controller.dart';
import '../widgets/canadian_theme.dart';
import 'test_session_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late Difficulty _selectedDifficulty;
  late Language _selectedLanguage;
  Set<QuestionType> _selectedTypes = {
    QuestionType.rightsResponsibilities,
    QuestionType.history,
    QuestionType.government,
    QuestionType.geography,
    QuestionType.symbols,
    QuestionType.economy,
  };
  final SmartLearningController _smartLearning = SmartLearningController();

  @override
  void initState() {
    super.initState();
    final settings = SettingsController();
    _selectedDifficulty = settings.defaultDifficulty;
    _selectedLanguage = settings.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
      ),
      body: CanadianBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildConfigurationCard(),
            const SizedBox(height: 16),
            _buildSmartPracticeCard(),
            const SizedBox(height: 24),
            Text(
              'Select Test Type',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildTestTypeCard(
              context,
              TestType.quickAssessment,
              Icons.timer_outlined,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildTestTypeCard(
              context,
              TestType.standardPractice,
              Icons.assignment_outlined,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildTestTypeCard(
              context,
              TestType.fullMock,
              Icons.quiz_outlined,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Difficulty>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(
                labelText: 'Difficulty Level',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.tune),
              ),
              items: Difficulty.values.map((difficulty) {
                return DropdownMenuItem(
                  value: difficulty,
                  child: Text(difficulty.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDifficulty = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Language>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              items: Language.values.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text('${lang.flag} ${lang.displayName}'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Topics',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: QuestionType.values.map((type) {
                final isSelected = _selectedTypes.contains(type);
                return FilterChip(
                  label: Text(type.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTypes.add(type);
                      } else {
                        if (_selectedTypes.length > 1) {
                          _selectedTypes.remove(type);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestTypeCard(
    BuildContext context,
    TestType type,
    IconData icon,
    Color color,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _startTest(type),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${type.defaultQuestionCount} Questions • ${type.defaultTimeMinutes} Minutes',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _startTest(TestType type) {
    final config = TestConfiguration(
      testType: type,
      difficulty: _selectedDifficulty,
      selectedTypes: _selectedTypes.toList(),
    );

    final questions = QuestionDataManager().getConfiguredQuestions(
      config,
      _selectedLanguage,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestSessionScreen(
          configuration: config,
          questions: questions,
          language: _selectedLanguage,
        ),
      ),
    );
  }

  Widget _buildSmartPracticeCard() {
    final weakAreas = _smartLearning.getWeakAreas();
    final reviewDue = _smartLearning.getQuestionsForReview();
    final bookmarkCount = _smartLearning.bookmarkCount;
    final hasData = _smartLearning.allStats.isNotEmpty;
    
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
            child: Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Practice',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Focus on your weak areas',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasData)
                  const Text(
                    'Complete some practice tests to unlock smart practice features!',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )
                else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSmartStat(
                        Icons.warning_amber,
                        Colors.orange,
                        '${weakAreas.length}',
                        'Weak Areas',
                      ),
                      _buildSmartStat(
                        Icons.replay,
                        Colors.blue,
                        '${reviewDue.length}',
                        'Due Review',
                      ),
                      _buildSmartStat(
                        Icons.bookmark,
                        Theme.of(context).colorScheme.primary,
                        '$bookmarkCount',
                        'Bookmarked',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: hasData ? () => _startSmartPractice(focusWeakAreas: true) : null,
                        icon: const Icon(Icons.gps_fixed),
                        label: const Text('Weak Areas'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: bookmarkCount > 0 ? () => _startSmartPractice(bookmarksOnly: true) : null,
                        icon: const Icon(Icons.bookmark),
                        label: const Text('Bookmarks'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartStat(IconData icon, Color color, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
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

  void _startSmartPractice({bool focusWeakAreas = false, bool bookmarksOnly = false}) {
    final config = TestConfiguration(
      testType: TestType.standardPractice,
      difficulty: _selectedDifficulty,
      selectedTypes: _selectedTypes.toList(),
    );

    // Get base questions
    var questions = QuestionDataManager().getConfiguredQuestions(
      config,
      _selectedLanguage,
    );

    // Filter for bookmarked questions if requested
    if (bookmarksOnly) {
      final bookmarkIds = _smartLearning.bookmarkedQuestionIds;
      questions = questions.where((q) => bookmarkIds.contains(q.id)).toList();
      
      if (questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No bookmarked questions available')),
        );
        return;
      }
    }

    // Take up to 15 questions for smart practice
    if (questions.length > 15) {
      questions = questions.take(15).toList();
    }

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No questions available for this criteria')),
      );
      return;
    }

    final smartConfig = TestConfiguration(
      testType: TestType.standardPractice,
      difficulty: _selectedDifficulty,
      selectedTypes: _selectedTypes.toList(),
      questionCount: questions.length,
      timeInMinutes: questions.length * 2, // 2 min per question
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestSessionScreen(
          configuration: smartConfig,
          questions: questions,
          language: _selectedLanguage,
        ),
      ),
    );
  }
}
