import 'package:flutter/material.dart';
import '../models/question.dart';

class StudyGuideScreen extends StatelessWidget {
  const StudyGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Guide'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Verbal Battery', Icons.chat_bubble_outline, Colors.blue),
          _buildGuideCard(
            context,
            title: 'Synonyms',
            icon: Icons.swap_horiz,
            color: Colors.blue,
            description: 'Find words that have the same or similar meaning.',
            tips: [
              'Look for words with the same meaning as the given word',
              'Consider the context and part of speech',
              'Eliminate words that are antonyms (opposites)',
              'Use your vocabulary knowledge and word roots',
            ],
            example: 'HAPPY → Joyful (both mean feeling pleasure)',
          ),
          _buildGuideCard(
            context,
            title: 'Antonyms',
            icon: Icons.flip,
            color: Colors.blue,
            description: 'Find words that have the opposite meaning.',
            tips: [
              'Think of what the word means, then find its opposite',
              'Be careful of words that sound similar but aren\'t antonyms',
              'Consider prefixes like "un-", "dis-", "in-" that create opposites',
              'Eliminate synonyms (same meaning) first',
            ],
            example: 'HOT → Cold (opposite temperatures)',
          ),
          _buildGuideCard(
            context,
            title: 'Verbal Analogies',
            icon: Icons.compare_arrows,
            color: Colors.blue,
            description: 'Questions test your ability to understand relationships between words.',
            tips: [
              'Identify the relationship between the first pair of words',
              'Look for the same relationship in the answer choices',
              'Common relationships: synonyms, antonyms, part-to-whole, cause-effect',
              'Example: Dog is to puppy as cat is to kitten (parent to offspring)',
            ],
            example: 'Hot : Cold :: Wet : ? → Answer: Dry (opposites)',
          ),
          _buildGuideCard(
            context,
            title: 'Sentence Completion',
            icon: Icons.text_fields,
            color: Colors.blue,
            description: 'Fill in the blank with the word that best completes the sentence.',
            tips: [
              'Read the entire sentence before looking at options',
              'Look for context clues (positive/negative tone, cause/effect)',
              'Eliminate obviously wrong answers first',
              'Check if your answer makes grammatical sense',
            ],
            example: 'The weather was _____, so we stayed inside. → Answer: rainy',
          ),
          _buildGuideCard(
            context,
            title: 'Verbal Classification',
            icon: Icons.category,
            color: Colors.blue,
            description: 'Identify which word does not belong with the others.',
            tips: [
              'Find what 3 items have in common',
              'The answer is the one that does NOT share that characteristic',
              'Consider multiple categories (function, type, origin)',
              'Think about synonyms and related concepts',
            ],
            example: 'Apple, Banana, Carrot, Orange → Answer: Carrot (not a fruit)',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Quantitative Battery', Icons.calculate_outlined, Colors.green),
          _buildGuideCard(
            context,
            title: 'Number Analogies',
            icon: Icons.trending_up,
            color: Colors.green,
            description: 'Find the pattern between number pairs and apply it.',
            tips: [
              'Identify the operation: +, -, ×, ÷, square, cube',
              'Check if numbers are doubled, tripled, squared, etc.',
              'Apply the same operation to find the missing number',
              'Common patterns: n×2, n², n³, n+constant',
            ],
            example: '2 : 4 :: 3 : ? → Answer: 6 (multiply by 2)',
          ),
          _buildGuideCard(
            context,
            title: 'Number Series',
            icon: Icons.format_list_numbered,
            color: Colors.green,
            description: 'Find the pattern in a sequence of numbers.',
            tips: [
              'Calculate differences between consecutive numbers',
              'Look for arithmetic (+same number) or geometric (×same number) patterns',
              'Check for alternating patterns or multiple operations',
              'Common: +2, ×2, squares (1,4,9,16), Fibonacci (1,1,2,3,5,8)',
            ],
            example: '2, 4, 6, 8, ? → Answer: 10 (add 2 each time)',
          ),
          _buildGuideCard(
            context,
            title: 'Quantitative Relations',
            icon: Icons.compare,
            color: Colors.green,
            description: 'Compare two quantities and determine which is greater.',
            tips: [
              'Calculate each quantity separately first',
              'Use estimation when exact calculation is complex',
              'Remember: equal values exist! Don\'t assume one is always greater',
              'Watch for negative numbers and fractions',
            ],
            example: 'A: 3² vs B: 2³ → A=9, B=8 → A is greater',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Non-Verbal Battery', Icons.grid_view_outlined, Colors.purple),
          _buildGuideCard(
            context,
            title: 'Figure Matrices',
            icon: Icons.apps,
            color: Colors.purple,
            description: 'Identify patterns in shapes across rows and columns.',
            tips: [
              'Look for changes in: shape, size, color, orientation, quantity',
              'Check both rows AND columns for patterns',
              'Common transformations: rotation, reflection, addition, removal',
              'The answer completes the pattern in all directions',
            ],
            example: 'Circle → Sphere means 2D to 3D, so Square → Cube',
          ),
          _buildGuideCard(
            context,
            title: 'Figure Classification',
            icon: Icons.view_module,
            color: Colors.purple,
            description: 'Find the figure that does not belong with the others.',
            tips: [
              'Count sides, angles, or components',
              'Check for symmetry (vertical, horizontal, rotational)',
              'Look at fill patterns (solid, striped, empty)',
              'Consider direction or orientation',
            ],
            example: '△ □ ○ ⬡ → Circle is different (no straight edges)',
          ),
          _buildGuideCard(
            context,
            title: 'Figure Series',
            icon: Icons.linear_scale,
            color: Colors.purple,
            description: 'Identify what comes next in a visual sequence.',
            tips: [
              'Track changes from one figure to the next',
              'Look for progressive transformations (rotating, growing, adding)',
              'The pattern should continue logically',
              'Consider multiple elements changing simultaneously',
            ],
            example: '| , || , ||| , ? → Answer: |||| (adding one line)',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'General Test-Taking Tips', Icons.lightbulb_outline, Colors.orange),
          _buildTipsCard(context, [
            '⏱️ **Time Management**: Don\'t spend too long on one question. Skip and return.',
            '❌ **Elimination**: Remove obviously wrong answers to improve your odds.',
            '🔄 **Review**: If time permits, review flagged or uncertain answers.',
            '😌 **Stay Calm**: Take a deep breath if you feel stuck. Stress hurts performance.',
            '📖 **Read Carefully**: Many mistakes come from misreading the question.',
            '✏️ **Practice**: The more you practice, the faster you\'ll recognize patterns.',
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required List<String> tips,
    required String example,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Tips & Strategies',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(tip)),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📝 Example',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(example),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context, List<String> tips) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tips.map((tip) {
            final parts = tip.split('**');
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: _parseMarkdownBold(tip, context),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<TextSpan> _parseMarkdownBold(String text, BuildContext context) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return spans;
  }
}
