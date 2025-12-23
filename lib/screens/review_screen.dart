import 'package:flutter/material.dart';
import '../models/question.dart';
import '../controllers/settings_controller.dart';

class ReviewScreen extends StatelessWidget {
  final List<Question> questions;
  final TestResult result;

  const ReviewScreen({
    super.key,
    required this.questions,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SettingsController(),
      builder: (context, child) {
        final language = SettingsController().language;
        final isFrench = language == Language.french;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(isFrench ? 'Révision des réponses' : 'Review Answers'),
          ),
          body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final userAnswer = result.answers.firstWhere(
            (a) => a.questionId == question.id,
            orElse: () => UserAnswer(
              questionId: question.id,
              selectedOption: -1,
              isCorrect: false,
              timeTaken: Duration.zero,
            ),
          );

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: userAnswer.isCorrect ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: userAnswer.isCorrect
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Question ${index + 1}',
                          style: TextStyle(
                            color: userAnswer.isCorrect
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (question.imageAsset != null)
                        const Icon(Icons.image, size: 20, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.getStem(language),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (question.imageAsset != null) ...[
                    const SizedBox(height: 12),
                    Image.asset(
                      question.imageAsset!,
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ...List.generate(question.options.length, (optIndex) {
                    final isSelected = userAnswer.selectedOption == optIndex;
                    final isCorrect = question.correctAnswer == optIndex;
                    
                    Color? backgroundColor;
                    Color borderColor;
                    IconData? icon;
                    Color? iconColor;

                    if (isCorrect) {
                      backgroundColor = Colors.green.withValues(alpha: 0.1);
                      borderColor = Colors.green;
                      icon = Icons.check_circle;
                      iconColor = Colors.green;
                    } else if (isSelected && !isCorrect) {
                      backgroundColor = Colors.red.withValues(alpha: 0.1);
                      borderColor = Colors.red;
                      icon = Icons.cancel;
                      iconColor = Colors.red;
                    } else {
                      backgroundColor = Colors.transparent;
                      borderColor = Colors.grey.shade300;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(
                          color: borderColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (icon != null) ...[
                            Icon(icon, color: iconColor, size: 20),
                            const SizedBox(width: 8),
                          ] else ...[
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + optIndex),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              question.getOptions(language)[optIndex],
                              style: TextStyle(
                                color: isCorrect || (isSelected && !isCorrect)
                                    ? Colors.black
                                    : Colors.grey.shade700,
                                fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (question.explanation.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 16,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isFrench ? 'Explication' : 'Explanation',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question.getExplanation(language),
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
      },
    );
  }
}
