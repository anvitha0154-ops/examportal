import 'package:flutter/material.dart';

import '../models/question.dart';

class AnalysisScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<Question> questions;
  final List<int> userAnswers;

  const AnalysisScreen({
    super.key,
    required this.score,
    required this.total,
    required this.questions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0 : (score * 100 / total).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Analysis'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Your Score',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$score / $total',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text('$percentage%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Answer Review',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < questions.length; index++)
            _QuestionReview(
              number: index + 1,
              question: questions[index],
              userAnswer:
                  index < userAnswers.length ? userAnswers[index] : null,
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}

class _QuestionReview extends StatelessWidget {
  final int number;
  final Question question;
  final int? userAnswer;

  const _QuestionReview({
    required this.number,
    required this.question,
    required this.userAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = userAnswer == question.correctIndex;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '$number. ${question.text}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < question.options.length; index++)
              _OptionRow(
                label: question.options[index],
                isCorrect: index == question.correctIndex,
                isSelected: index == userAnswer,
              ),
            const SizedBox(height: 8),
            Text(
              'Explanation: ${question.explanation}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final String label;
  final bool isCorrect;
  final bool isSelected;

  const _OptionRow({
    required this.label,
    required this.isCorrect,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (isCorrect) {
      color = Colors.green.shade50;
    } else if (isSelected) {
      color = Colors.red.shade50;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect
              ? Colors.green
              : isSelected
                  ? Colors.red
                  : Colors.grey.shade300,
        ),
      ),
      child: Text(label),
    );
  }
}
