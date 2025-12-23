import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../controllers/smart_learning_controller.dart';
import '../controllers/gamification_controller.dart';
import '../widgets/canadian_theme.dart';
import 'results_screen.dart';

class TestSessionScreen extends StatefulWidget {
  final TestConfiguration configuration;
  final List<Question> questions;
  final Language language;

  const TestSessionScreen({
    super.key,
    required this.configuration,
    required this.questions,
    required this.language,
  });

  @override
  State<TestSessionScreen> createState() => _TestSessionScreenState();
}

class _TestSessionScreenState extends State<TestSessionScreen> {
  int _currentIndex = 0;
  final Map<String, int> _answers = {};
  final Map<String, int> _timeSpent = {}; // In seconds
  late Timer _timer;
  int _secondsRemaining = 0;
  DateTime _startTime = DateTime.now();
  DateTime _questionStartTime = DateTime.now();
  final SmartLearningController _smartLearning = SmartLearningController();
  final GamificationController _gamification = GamificationController();
  
  // Track gamification rewards to show
  int _totalPointsEarned = 0;
  int _totalXPEarned = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.configuration.timeInMinutes * 60;
    _startTimer();
    _questionStartTime = DateTime.now();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _finishTest();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _finishTest() {
    _timer.cancel();
    
    // Record time for last question
    _recordTimeForCurrentQuestion();

    // Compile results
    List<UserAnswer> userAnswers = [];
    int correctCount = 0;
    Map<QuestionType, int> scoreByType = {};
    Map<String, int> scoreBySubType = {};

    for (var question in widget.questions) {
      int selectedOption = _answers[question.id] ?? -1;
      bool isCorrect = selectedOption == question.correctAnswer;
      
      if (isCorrect) {
        correctCount++;
        scoreByType[question.type] = (scoreByType[question.type] ?? 0) + 1;
        scoreBySubType[question.subType] = (scoreBySubType[question.subType] ?? 0) + 1;
      }

      userAnswers.add(UserAnswer(
        questionId: question.id,
        selectedOption: selectedOption,
        isCorrect: isCorrect,
        timeTaken: Duration(seconds: _timeSpent[question.id] ?? 0),
      ));
      
      // Award gamification points for each answer
      final reward = _gamification.recordAnswer(
        isCorrect: isCorrect,
        questionType: question.type.toString(),
      );
      _totalPointsEarned += reward.pointsEarned;
      _totalXPEarned += reward.xpEarned;
    }

    // Record answers in SmartLearningController with timing
    final totalTimeSeconds = DateTime.now().difference(_startTime).inSeconds;
    _smartLearning.recordTestSessionWithTime(widget.questions, userAnswers, totalTimeSeconds);
    
    // Award test completion bonus
    final completionReward = _gamification.recordTestCompletion(
      totalQuestions: widget.questions.length,
      correctAnswers: correctCount,
      totalTimeSeconds: totalTimeSeconds,
    );
    _totalPointsEarned += completionReward.pointsEarned;
    _totalXPEarned += completionReward.xpEarned;

    final result = TestResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      completedAt: DateTime.now(),
      configuration: widget.configuration,
      answers: userAnswers,
      totalQuestions: widget.questions.length,
      correctAnswers: correctCount,
      totalTime: DateTime.now().difference(_startTime),
      scoreByType: scoreByType,
      scoreBySubType: scoreBySubType,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          result: result,
          questions: widget.questions,
          pointsEarned: _totalPointsEarned,
          xpEarned: _totalXPEarned,
          leveledUp: completionReward.leveledUp,
          newLevel: completionReward.newLevel,
        ),
      ),
    );
  }

  void _recordTimeForCurrentQuestion() {
    final questionId = widget.questions[_currentIndex].id;
    final duration = DateTime.now().difference(_questionStartTime).inSeconds;
    _timeSpent[questionId] = (_timeSpent[questionId] ?? 0) + duration;
  }

  void _nextQuestion() {
    _recordTimeForCurrentQuestion();
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _questionStartTime = DateTime.now();
      });
    } else {
      _finishTest();
    }
  }

  void _previousQuestion() {
    _recordTimeForCurrentQuestion();
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _questionStartTime = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${widget.questions.length}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: progress),
        ),
        actions: [
          // Bookmark button
          IconButton(
            onPressed: () {
              setState(() {
                _smartLearning.toggleBookmark(question.id);
              });
            },
            icon: Icon(
              _smartLearning.isBookmarked(question.id)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: _smartLearning.isBookmarked(question.id)
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            tooltip: 'Bookmark question',
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: CanadianBackground(
        showMapleLeaves: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuestionHeader(question),
                    const SizedBox(height: 24),
                    if (question.imageAsset != null) ...[
                      Center(
                        child: Image.asset(
                          question.imageAsset!,
                          height: 200,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 100,
                              child: Center(
                                child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    CanadianQuestionCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          question.getStem(widget.language),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildOptions(question),
                  ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
      ),
    );
  }

  Widget _buildQuestionHeader(Question question) {
    return Row(
      children: [
        Chip(
          label: Text(question.type.displayName),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        const SizedBox(width: 8),
        Chip(
          label: Text(question.difficulty.displayName),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ],
    );
  }

  Widget _buildOptions(Question question) {
    final options = question.getOptions(widget.language);
    
    return Column(
      children: List.generate(options.length, (index) {
        final isSelected = _answers[question.id] == index;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: isSelected ? 2 : 0,
            color: isSelected 
                ? Theme.of(context).colorScheme.primaryContainer 
                : Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _answers[question.id] = index;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary 
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected 
                              ? Theme.of(context).colorScheme.primary 
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                            color: isSelected 
                                ? Theme.of(context).colorScheme.onPrimary 
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        options[index],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentIndex > 0)
            OutlinedButton.icon(
              onPressed: _previousQuestion,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            )
          else
            const SizedBox(width: 100),
          
          FilledButton.icon(
            onPressed: _nextQuestion,
            icon: Icon(_currentIndex == widget.questions.length - 1 
                ? Icons.check 
                : Icons.arrow_forward),
            label: Text(_currentIndex == widget.questions.length - 1 
                ? 'Finish' 
                : 'Next'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
